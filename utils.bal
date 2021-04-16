//import ballerina/http;

// isolated  function getOAuthConfig (Configuration config) returns http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig{
//     var clientConfig = config.clientConfig;
//     if clientConfig is http:BearerTokenConfig {
//         return clientConfig;
//     } else {
//         http:OAuth2RefreshTokenGrantConfig refreshTokenConfig;
//         string tenantId = clientConfig.tenantId;
//         string refreshUrl = TOKEN_ENDPOINT + tenantId + TOKEN_PATH;
//         refreshTokenConfig = {
//             refreshUrl: refreshUrl,
//             refreshToken : clientConfig.refreshToken,
//             clientId : clientConfig.clientId,
//             clientSecret : clientConfig.clientSecret,
//             scopes : <string[]> clientConfig?.scopes
//         };
//         return refreshTokenConfig;
//     }
// }

isolated function prepareUrl(string[] paths, string[]? queryParams = []) returns string {
    string url = "";
    string validatedQueryParams = "";

    if paths.length() > 0 {
        foreach var path in paths {
            if (!path.startsWith(FORWARD_SLASH)) {
                url = url + FORWARD_SLASH;
            }
            url = url + path;
        }
    }
    if queryParams is string[] {
        if queryParams.length() > 0 {
            foreach string query in queryParams {
                if query.startsWith("$"){
                    string[] paranthesisArr = [];
                    foreach string character in query {
                        if character == "(" {
                            paranthesisArr.push(character);
                        } else if character == ")" {
                            _ = paranthesisArr.pop();
                        }
                    }
                    if (paranthesisArr.length() == 0){
                        validatedQueryParams = validatedQueryParams + "&" + query;
                    }
                } else {
                    if validatedQueryParams != ""{
                        validatedQueryParams = validatedQueryParams + "&" + query;
                    } else {
                        validatedQueryParams = query;
                    }
                }
            }
            url = url + "?" + validatedQueryParams;
        }
    } 
    return <@untainted>url;
}

isolated function getCalendarPath(string? calendarGroupId = (), string? calendarId = ()) returns string[] {
    string[] paths = [];
    if calendarGroupId is string && calendarId is string {
        paths = [PROFILE, CALENDAR_GROUPS, calendarGroupId, CALENDARS, calendarId];
    } else {
        if calendarId is string {
            paths = [PROFILE, CALENDARS, calendarId];
        }
        else {
            paths = [PROFILE, CALENDAR];
        }
    } 
    return paths;
}