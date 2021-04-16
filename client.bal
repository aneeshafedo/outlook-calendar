import ballerina/http;
import ballerina/log;

public client class Client {
    http:Client httpClient;

    public function init(Configuration config) returns error? {
        http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig clientConfig = config.clientConfig;
        http:ClientSecureSocket? socketConfig = config?.secureSocketConfig;
        self.httpClient = check new (ENDPOINT_URL, {
            auth: clientConfig,
            secureSocket: socketConfig
        });
    }
    //what we should return? json or a record?
    remote function listCalendars(string[]? queryParams = ()) returns CalendarCollection|error {
        string path = prepareUrl([PROFILE, CALENDARS], queryParams);
        http:Response response = check self.httpClient->get(path);
        json payload = check response.getJsonPayload();
        return check payload.cloneWithType(CalendarCollection);
    }

    remote function createCalendar(string calendarName) returns Calendar|error {
        json requestPayload = {"name": calendarName};
        string path = prepareUrl([PROFILE, CALENDARS]);
        http:Response response = check self.httpClient->post(path, requestPayload);
        json payload = check response.getJsonPayload();
        return check payload.cloneWithType(Calendar);
    }

    remote function getCalendar(string? calendarId = (), string? calendarGroupId = (), string[]? queryParams = ()) returns Calendar|error {
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
        string path = prepareUrl(paths, queryParams);
        log:printInfo("Path : " + path);
        http:Response response = check self.httpClient->get(path);
        json payload = check response.getJsonPayload();
        log:printInfo("payload : " +  payload.toString());
        return check payload.cloneWithType(Calendar);
    }

    remote function updateCalendar(Calendar calendarDetails, string? calendarId = (), string? calendarGroupId = ()) returns Calendar|error{
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
        json calendarDetailsJson = check calendarDetails.cloneWithType(json);
        string path = prepareUrl(paths);
        http:Response response = check self.httpClient->patch(path, calendarDetailsJson);
        json payload = check response.getJsonPayload();
        return check payload.cloneWithType(Calendar);
    }

    remote function deleteCalendar(string calendarId, string? calendarGroupId = ()) returns error?{
        string[] paths = [];
        if calendarGroupId is string{
            paths = [PROFILE, CALENDAR_GROUPS, calendarGroupId, CALENDARS, calendarId];
        } else {
            paths = [PROFILE, CALENDARS, calendarId];
        } 
        string path = prepareUrl(paths);
        http:Response response = check self.httpClient->delete(path);
        log:printInfo("Response : " + response.statusCode.toString());
        string statusCode = response.statusCode.toString();
        if (statusCode != "204") {
            return error(DELETE_FAILED_MSG);
        } 
    }

    remote function listCalendarView(string startDateTime, string endDateTime, string calendarId, string? calendarGroupId = ()) returns error|EventCollection{
        string[] paths = getCalendarPath(calendarId, calendarGroupId);
        paths.push(CALENDAR_VIEW);
        string startDateTimeQuery = string `startDateTime=${startDateTime};`;
        string endDateTimeQuery = string `endDateTime=${endDateTime}`;
        string[] queryParams = [startDateTimeQuery, endDateTimeQuery];
        string path = prepareUrl(paths, queryParams);
        log:printInfo("Path : " + path);
        http:Response response = check self.httpClient->get(path);
        json payload = check response.getJsonPayload();
        log:printInfo("Payload : " + payload.toString());
        return check payload.cloneWithType(EventCollection);
    }

}

//everything is working
//use Azure AD v2.0 Protocols in postman to get access token
//scopes are provided as urls 
//implement all the operation
//set time outs
//list the operations available