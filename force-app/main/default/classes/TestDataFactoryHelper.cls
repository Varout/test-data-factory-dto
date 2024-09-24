/**
 * A collection of static variables and functions used in unit tests
 * @see: TestDataFactory.cls - Main factory class
 * @see: TestDataFactoryDto.cls - Data transfer object class
 */
@isTest
public class TestDataFactoryHelper {
    final public static String EMAIL_NO_PERMS = 'NO_SINGLE_MAIL_PERMISSION';
    final public static Boolean IS_SANDBOX = [
        SELECT IsSandbox
        FROM Organization
    ]
    .IsSandbox;

    /*  ****************************************  */
    /*               General Purpose              */
    /*  ****************************************  */
    /**
     * Creates a fake record Id for an SObject of length 18.
     * e.g. getFakeSObjectId(Account.getSObjectType())
     * @param   SObjectType
     * @return  Id
     */
    //  Allows for more than one SObject Id to be created per function call
    private static Integer recordNumber = 1;
    public static String getFakeSObjectId(Schema.SObjectType testSObjType) {
        String recNum = String.valueOf(recordNumber++);
        String fakeRecordId =
            testSObjType.getDescribe().getKeyPrefix() +
            '0'.repeat(15 - recNum.length()) +
            recNum;
        return fakeRecordId;
    }

    /**
     * Create random Integer values
     */
    public static Integer getRandInt() {
        return getRandIntWithMax(100000);
    }

    public static Integer getRandIntWithMax(Integer maxValue) {
        return Integer.valueOf(Math.random() * Math.random() * maxValue);
    }

    /**
     * Makes labels API naming compliant for Salesforce
     */
    public static String convertLabelToAPIName(String labelToConvert) {
        return labelToConvert.replaceAll('[^a-zA-Z0-9]', '_') + '__c';
    }

    /**
     * From a String of an SObject name, return that SObject's 3 letter prefix
     * @param   String. SObject name
     * @return  String. 3 letter SObject prefix
     */
    public static String getSObjectPrefix(String sObjectName) {
        try {
            Schema.SObjectType sObjType = Schema.getGlobalDescribe()
                .get(sObjectName);

            return sObjType.getDescribe().getKeyPrefix();
        } catch (Exception e) {
            System.debug(
                'Exception: Tried to get the SObject Id prefix for: ' +
                sObjectName
            );
            System.debug(e.getMessage());
        }
        return null;
    }

    /**
     * Query and return a single SObject record using the SObject API name.
     * The record will contain only the Id value. If any number other than
     * one record is returned from the query, a null value is returned.
     * @param   String. SObject API Name
     * @return  SObject
     */
    public static SObject querySingleRecordBySObjectName(String sObjectName) {
        String queryString = '';
        queryString += 'SELECT Id\n';
        queryString += 'FROM ' + sObjectName;

        List<SObject> results = Database.query(queryString);
        if (results.size() > 0) {
            return results[0];
        }
        return null;
    }

    /**
     * Query and return a single SObject record Id using the SObject API name.
     * If any number other than one record is returned from the query, a null
     * value is returned.
     * @return  Id
     */
    public static Id querySingleRecordIdBySObjectName(String sObjectName) {
        return querySingleRecordBySObjectName(sObjectName).Id;
    }

    /**
     * Query a test User by LastName and return it
     * @param   String. User.LastName
     */
    public static User queryUserByLastName(String userLastName) {
        List<User> testUsers = [
            SELECT Id, FirstName, LastName, Email, ProfileId
            FROM User
            WHERE LastName = :userLastName
        ];

        if (testUsers.size() == 1) {
            return testUsers[0];
        }
        return null;
    }

    /**
     * Query all EmailMessage records, emails that have been successfully sent or queued to be sent
     * Statuses: 0 - New, 1 - Read, 2 - Replied, 3 - Sent, 4 - Forwarded, 5 - Draft
     * @return  List<EmailMessage>
     */
    public static List<EmailMessage> querySentEmails() {
        return [
            SELECT
                Id,
                Status,
                Subject,
                TextBody,
                ToAddress,
                CcAddress,
                BccAddress,
                RelatedToId
            FROM EmailMessage
        ];
    }

    /**
     * Query a CronTrigger by Id. Used for scheduled jobs
     * @param   Id. CronTrigger.Id
     * @return  List<CronTrigger>
     */
    public static List<CronTrigger> queryCronTriggerById(Id jobId) {
        return [
            SELECT Id, CronJobDetailId, State, TimesTriggered, CronExpression
            FROM CronTrigger
            WHERE Id = :jobId
        ];
    }

    /**
     * Query a CronJobDetail by Id. Used for scheduled jobs.
     * Uses the CronTrigger.CronJobDetailId value
     * @param   Id. CronJobDetail.Id
     * @return  List<CronJobDetail>
     */
    public static List<CronJobDetail> queryCronJobDetailById(Id jobDetailId) {
        return [
            SELECT Id, Name, JobType
            FROM CronJobDetail
            WHERE Id = :jobDetailId
        ];
    }

    /**
     * Queries an SObject type (including Custom Metadata) for all records,
     * and returns a random one from that list with all fields queried
     * @param   String. SObject API Name (e.g. Opportunity, Custom_Object__c)
     * @return  SObject
     */
    public static SObject queryRecordByType(String sObjectApiName) {
        Set<String> fieldNames = new Set<String>();
        List<Schema.SObjectField> sObjFields = Schema.getGlobalDescribe()
            .get(sObjectApiName)
            .getDescribe()
            .fields.getMap()
            .values();
        for (Schema.SObjectField sof : sObjFields) {
            fieldNames.add(sof.getDescribe().getName());
        }

        String queryString =
            'SELECT ' +
            String.join(fieldNames, ',\n') +
            '\nFROM ' +
            sObjectApiName;

        List<SObject> results = Database.query(queryString);
        Integer randPosition = getRandIntWithMax(results.size()) - 1;

        return results[randPosition];
    }
}
