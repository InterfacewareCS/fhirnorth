local hFunctions = require ('helper')

local this = {}

function this.createPatientResource (token, Data, fhirClient)
   -- 1. Create Content type
   local cont = {'Content-Type: application/fhir+json',token}

   -- 2. Post to FHIR Server
   local PostResult, PostCode, PostHeaders = fhirClient.resources.Patient.create(Data, nil, cont)
   return PostCode, PostResult
end

function this.searchPatientResource (token, searchStr, fhirClient)
   -- 1. Create Content type
   local cont = {'Content-Type: application/fhir+json',token}

   -- 2. Post to FHIR Server
   local PostResult, PostCode, PostHeaders = fhirClient.resources.Patient.search("json", searchStr, cont)
   return PostCode, PostResult
end

function this.createEncounterResource (token, Data, fhirClient)
   -- 1. Create Content type
   local cont = {'Content-Type: application/fhir+json',token}

   -- 2. Post to FHIR Server
   local PostResult, PostCode, PostHeaders = fhirClient.resources.Encounter.create(Data, nil, cont)
   return PostCode, PostResult
end

function this.createObservationResource (token, Data, fhirClient)
   -- 1. Create Content type
   local cont = {'Content-Type: application/fhir+json',token}

   -- 2. Post to FHIR Server
   local PostResult, PostCode, PostHeaders = fhirClient.resources.Observation.create(Data, nil, cont)
   return PostCode, PostResult
end

function this.createSpecimenResource (token, Data, fhirClient)
   -- 1. Create Content type
   local cont = {'Content-Type: application/fhir+json',token}

   -- 2. Post to FHIR Server
   local PostResult, PostCode, PostHeaders = fhirClient.resources.Specimen.create(Data, nil, cont)
   return PostCode, PostResult
end

function this.createDiagnosticResource (token, Data, fhirClient)
   -- 1. Create Content type
   local cont = {'Content-Type: application/fhir+json',token}

   -- 2. Post to FHIR Server
   local PostResult, PostCode, PostHeaders = fhirClient.resources.DiagnosticReport.create(Data, nil, cont)
   return PostCode, PostResult
end

return this 

