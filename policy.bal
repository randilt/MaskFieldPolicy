import ballerina/http;
import choreo/mediation;

@mediation:ResponseFlow
public function maskPayerName(mediation:Context ctx, http:Request req, http:Response res, 
                                string fieldName, int visibleChars) 
                                returns http:Response|false|error|() {

    json|http:ClientError payload = res.getJsonPayload();
    if payload is http:ClientError {
        // Not a JSON body (e.g. error response) — pass through unchanged
        return ();
    }

    json masked = check maskField(payload, fieldName, visibleChars);
    res.setJsonPayload(masked);

    return ();
}

function maskField(json payload, string fieldName, int visibleChars) returns json|error {
    if payload is json[] {
        json[] result = [];
        foreach json item in payload {
            result.push(check maskRecord(item, fieldName, visibleChars));
        }
        return result;
    }
    return maskRecord(payload, fieldName, visibleChars);
}

function maskRecord(json item, string fieldName, int visibleChars) returns json|error {
    if item !is map<json> {
        return item;
    }
    map<json> obj = <map<json>>item;

    if obj.hasKey(fieldName) {
        json fieldVal = obj[fieldName];
        if fieldVal is string {
            int len = fieldVal.length();
            if len > visibleChars {
                string visible = fieldVal.substring(len - visibleChars);
                string masked = "";
                foreach int i in 0 ..< (len - visibleChars) {
                    masked = masked + "*";
                }
                obj[fieldName] = masked + visible;
            }
        }
    }

    return obj;
}