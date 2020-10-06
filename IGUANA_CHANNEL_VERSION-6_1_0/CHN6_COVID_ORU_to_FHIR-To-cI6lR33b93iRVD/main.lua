--This is a POC script that will take an incoming HL7 ORU Message, Parse it, and upload it to a FHIR Server.
local fhirClient   = require "fhir.client"
local hFunctions = require 'helper'
local fapi = require 'fhir.fhirAPI'
local m_Db = db.connect{api=db.SQLITE, name='token.db'}
local templates = require 'data.resourceTemplates'
local mappings = require 'data.mappings'

function main(Data)
   -- 1. Parse ORU Message
   local oru,hl7name = hl7.parse{vmd="ORUR01_251.vmd",data=Data}

   if hl7name == "ORUR01" then
      -- 2. Initialize Server
      local ServerUrl = hFunctions.AZURE_FHIR_URL()
      fhirClient.initialize(ServerUrl)

      -- 3. Retreive token
      local token = hFunctions.generateToken(m_Db)

      -- 4. Search Patient from FHIR Server
      local given = oru.PATIENT_RESULT[1].PATIENT.PID[5][1][2]:nodeValue()
      local family = oru.PATIENT_RESULT[1].PATIENT.PID[5][1][1][1]:nodeValue()
      local patSearchStr = "given="..given.."&family="..family
      local Status, Code, Result = pcall(fapi.searchPatientResource, token, patSearchStr, fhirClient)

      -- 5. Insert Observation, Specimen, and Diagnostic Report to FHIR server
      if Status then 
         local jData = json.parse{data=Result}
         if jData.entry ~= nil then
            local patientID = jData.entry[1].resource.id

            local obsList = oru.PATIENT_RESULT[1].ORDER_OBSERVATION
            for i=1, #obsList do
               local obs = obsList[i]

               -- insert Specimen
               local specimen = obs.SPECIMEN[1].SPM
               local speJSON = mappings.specimenMapping(specimen, templates.getSpecimenTemplate(), patientID)
               local Status, Code, Result = pcall(fapi.createSpecimenResource, token, speJSON, fhirClient)
               if Status then
                  local specimenID = json.parse{data=Result}.id

                  -- insert Obervation
                  local obsItems = obs.OBSERVATION
                  for i=1, #obsItems do
                     local obsItem = obsItems[i]
                     local obsJSON = mappings.observationMapping(obsItem.OBX, templates.getObservationTemplate(), patientID, specimenID)
                     local Status, Code, Result = pcall(fapi.createObservationResource, token, obsJSON, fhirClient)
                     if Status then
                        local observationID = json.parse{data=Result}.id

                        -- insert Diagnostic Report
                        local diagJSON = mappings.diagnosticMapping(obs.OBR, obsItem.OBX, templates.getDiagnosticTemplate(), patientID, specimenID, observationID)
                        local Status, Code, Result = pcall(fapi.createDiagnosticResource, token, diagJSON, fhirClient)
                     end
                  end
               end
            end
         end
      end
   end   
end
