//import ballerina/time;
import ballerina/http;
public type Configuration record {|
    http:BearerTokenConfig|http:OAuth2RefreshTokenGrantConfig clientConfig;
    http:ClientSecureSocket secureSocketConfig?;
|};

//is this name okay ? Http has the same name. OAuth2RefreshTokenGrantConfig
// public type RefreshTokenGrantConfig record {|
//     string tenantId;
//     string refreshToken;
//     string clientId;
//     string clientSecret;
//     string[] scopes;
// |};

public type Calendar record {
    string name;
    boolean isDefaultCalendar?;
    string[] allowedOnlineMeetingProviders?;
    boolean canEdit?;
    boolean canShare?;
    boolean canViewPrivateItems?;
    string changeKey?;
    string color?;
    string defaultOnlineMeetingProvider?;
    string hexColor?;
    string id?;
    boolean isRemovable?;
    boolean isTallyingResponses?;
    json? owner?;
};

public type CalendarCollection record {
    Calendar[] value;
}; 

public type EventCollection record {
    Event[] value;
};

public type Event record {
    boolean allowNewTimeProposals?;
    Attendee[] attendees?;
    ItemBody body?;
    string bodyPreview?;
    string[] categories?;
    string changeKey?;
    string createdDateTime?;
    DateTimeZone end?;
    boolean hasAttachments?;
    boolean hideAttendees?;
    string iCalUId?;
    string id?;
    string importance?;
    boolean isAllDay?;
    boolean isCancelled?;
    boolean isDraft?;
    boolean isOnlineMeeting?;
    boolean isOrganizer?;
    boolean isReminderOn?; 
    //time:Utc lastModifiedDateTime?;
    //more to add......
 
};

public type Attendee record {
    json? emailAddress;
    //record type is optional and not sure about the type either
    json? proposedNewTime?;
    json? status?;
    string 'type?;
};

public type ItemBody record {
    string content;
    string contentType;
};

public type DateTimeZone record {
    string dateTime;
    string timeZone;
};