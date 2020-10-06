local dateparse = require 'date.parse'

local this = {}

-- Private Functions and variables --
local statusCodes = json.parse{data=[[{
   "observationResultStatusCodes": {
      "P": "preliminary",
      "C": "corrected",
      "R": "registered ",
      "U": "final",
      "D": "cancelled",
      "W": "entered in Error",
      "F": "final",
      "I": "amended",
      "X": "unknown",
      "S": "preliminary",
      "O": "unknown",
      "N": "unknown"
   }
}]]}

-- Public Funtions --
function this.encounterMapping(hl7, encounter, patientID)
   encounter.status = "finished"
   encounter.subject.reference = "Patient/"..patientID
   return json.serialize{data=encounter}
end

function this.observationMapping(hl7OBX, obs, patientID, specimenID)
   obs.subject.reference = "Patient/"..patientID
   if (specimenID ~= nil) then
      obs.specimen.reference = "Specimen/"..specimenID
   end
   obs.identifier[1].value = "COVIDMRNQuery"..hl7OBX[3][1]
   obs.status = statusCodes.observationResultStatusCodes[hl7OBX[11]:nodeValue()]
   obs.code.coding[1].display = hl7OBX[3][2]
   obs.code.coding[1].code = hl7OBX[3][1]
   obs.code.text = hl7OBX[3][2]
   obs.valueString = hl7OBX[5][1][2]
   obs.issued = hl7OBX[19][1]:T():gsub(" ", "T")
   return json.serialize{data=obs}
end


function this.specimenMapping(hl7SPM, specimen, patientID)
   specimen.subject.reference = "Patient/"..patientID
   specimen.type.coding[1].display = hl7SPM[4][2]
   specimen.type.coding[1].code = hl7SPM[4][1]
   specimen.type.coding[1].system = " http://snomed.info/sct"
   specimen.receivedTime = hl7SPM[18][1]:T():gsub(" ", "T")
   specimen.collection.collectedPeriod.start = hl7SPM[17]:T():gsub(" ", "T")
   return json.serialize{data=specimen}
end

function this.diagnosticMapping(hl7OBR, hl7OBX, diagnostic, patientID, specimenID, observationID)
   diagnostic.identifier[1].value = "COVIDMRNQuery"..hl7OBR[3][1]
   diagnostic.status = statusCodes.observationResultStatusCodes[hl7OBX[11]:nodeValue()]
   diagnostic.code.coding[1].code = hl7OBR[4][1]
   diagnostic.code.coding[1].display = hl7OBR[4][2]
   diagnostic.subject.reference = "Patient/"..patientID
   diagnostic.issued = hl7OBR[22][1]:T():gsub(" ", "T")
   diagnostic.specimen[1].reference = "Specimen/"..specimenID
   diagnostic.result[1].reference = "Observation/"..observationID
   diagnostic.conclusion = hl7OBX[5][1][2]
   return json.serialize{data=diagnostic}
end

return this