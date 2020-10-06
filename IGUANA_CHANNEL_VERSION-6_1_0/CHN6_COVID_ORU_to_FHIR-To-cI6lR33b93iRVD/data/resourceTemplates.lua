local this = {}

function this.getEncounterTemplate()
   local template = [==[
   {
      "resourceType": "Encounter",
      "status": "finished",
      "class": {
        "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
        "code": "LABOE",
       "display": "laboratory test order entry task"
      },
      "subject": {
        "reference": "Patient/a2bbd241-b3bf-4982-ad9a-57d573b2cbf8"
       }
   }
   ]==]
   
   return json.parse{data=template}
end

function this.getSpecimenTemplate()
   local template = [==[
   {
            "resourceType": "Specimen",
            "type": {
                "coding":  [
                    {
                        "system": "http://snomed.info/sct",
                        "code": "258500001",
                        "display": "Nasopharyngeal swab (specimen)"
                    }
                ]
            },
            "subject": {
                "reference": "Patient/be0f123c-2221-44d5-8bc7-a0fd3e4ff568"
            },
            "receivedTime": "2020-10-01T07:00:13-04:00",
            "collection": {
                "collectedPeriod": {
                    "start": "2020-10-01T07:00:13-04:00"
                }
            }
        }

   ]==]
   
   return json.parse{data=template}
end

function this.getObservationTemplate()
   local template =  [==[
   {
            "resourceType": "Observation",
            "identifier":  [
                {
                    "system": "http://acme.com/lab/reports",
                    "value": "COVIDMRNquery1-001",
                }
            ],
            "status": "final",
            "category":  [
                {
                    "coding":  [
                        {
                            "system": "http://hl7.org/fhir/observation-category",
                            "code": "laboratory"
                        }
                    ]
                }
            ],
            "code": {
                "coding":  [
                    {
                        "system": "http://loinc.org/",
                        "code": "94314-2",
                        "display": "2019 Novel coronavirus RdRp gene:PrThr:Pt:XXX:Ord:Probe.amp.tar"
                    }
                ],
                "text": "2019 Novel coronavirus RdRp gene"
            },
            "subject": {
                "reference": "Patient/a2bbd241-b3bf-4982-ad9a-57d573b2cbf8"
            },
            "issued": "2020-05-27T17:38:45-04:00",
            "valueString": "Detected",
            "specimen": {
                "reference": "Specimen/ce3fb407-68e3-47fb-b08c-9b4f6413ced5"
            }
        }
   ]==]
   
   return json.parse{data=template}
end

function this.getDiagnosticTemplate()
   local template = [==[
   {
    "resourceType": "DiagnosticReport",
    "identifier":  [
        {
            "system": "http://acme.com/lab/reports",
            "value": "COVIDMRNquery1"
        }
    ],
    "status": "final",
    "code": {
        "coding":  [
            {
                "code": "11502-2",
                "display": "Laboratory Report"
            }
        ]
    },
    "subject": {
        "reference": "Patient/ce3fb407-68e3-47fb-b08c-9b4f6413ced5"
    },
    "issued": "2020-08-19",
    "specimen":  [
        {
            "reference": "Specimen/ce3fb407-68e3-47fb-b08c-9b4f6413ced5"
        }
    ],
    "result":  [
        {
            "reference": "Observation/ce3fb407-68e3-47fb-b08c-9b4f6413ced5"
        }
    ],
    "conclusion": "Positive"
}
   ]==]
   
   return json.parse{data=template}
end

return this