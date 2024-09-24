/**
 * Used to simplify the creation of test records.
 * @see Class: TestDataFactory. Uses this clase to create test data
 * @desc The function buildTestRecord() is used to do the heavy lifting and create the test record(s).
 *       Functions that begin with 'set' or 'unset' are used to set or unset field values while creating
 *       the map of an SObject. Values need to stored as a String, so Integers, Dates, DateTimes, etc need
 *       to be converted before being mapped.
 *       Functions that begin with 'get' then have the SObject name appended are used by the TestDataFactory
 *       to build and retrieve the SObject that has been created with the set and unset functions.
 *       Remember that when using this approach for the field API name, it is case sensitive.
 */
@isTest
public class TestDataFactoryDto {
    //  Record to be build and then returned as a specific SObject
    private Map<String, String> testRecordMap;

    //  Default values that can be used
    private final String DEFAULT_FIRSTNAME = 'Hine';
    private final String DEFAULT_LASTNAME = 'Ahuone';
    private final String DEFAULT_EMAIL = 'test@example.com';
    private final String DEFAULT_ATTACHMENT_NAME = 'TestAttachment';

    //  Default address details
    private final String DEFAULT_STREET = 'Twin Coast Discovery Hwy';
    private final String DEFAULT_CITY = 'Waipoua Kauri Forest';
    private final String DEFAULT_POSTCODE = '0376'; //  Postal code for an area in Northland, Aotearoa
    private final String DEFAULT_COUNTRY = 'New Zealand'; //  Aotearoa

    //  Used for deciding a decimal conversion
    private final Set<String> DECIMAL_TYPES = new Set<String>{
        'CURRENCY',
        'DECIMAL',
        'DOUBLE',
        'LONG',
        'NUMBER',
        'PERCENT'
    };

    /**
     * These are SObjects where the Name field is not editable
     */
    private final Set<String> UNWRITEABLE_NAME = new Set<String>{
        'CampaignMember',
        'Contact'
    };

    private final Set<String> BLOB_FIELDS = new Set<String>{ 'VersionData' };

    /*  ****************************************  */
    /*             Helpful Singletons             */
    /*  ****************************************  */
    //  Mapping Profile.Name to Profile.Id
    private Map<String, Id> mapProfileNameToId {
        get {
            //  If the map is null or empty, popolate it
            if (
                this.mapProfileNameToId == null ||
                this.mapProfileNameToId.isEmpty()
            ) {
                this.mapProfileNameToId = new Map<String, Id>();
                for (Profile orgProfile : [SELECT Id, Name FROM Profile]) {
                    this.mapProfileNameToId.put(orgProfile.Name, orgProfile.Id);
                }
            }

            //  Return the map at the end
            return this.mapProfileNameToId;
        }
        set;
    }

    //  Mapping PermissionSet.Name to PermissionSet.Id
    private Map<String, Id> mapPermissionSetNameToId {
        get {
            //  If the map is null or empty, popolate it
            if (
                this.mapPermissionSetNameToId == null ||
                this.mapPermissionSetNameToId.isEmpty()
            ) {
                this.mapPermissionSetNameToId = new Map<String, Id>();
                for (PermissionSet orgPermSet : [
                    SELECT Id, Name
                    FROM PermissionSet
                ]) {
                    this.mapPermissionSetNameToId.put(
                        orgPermSet.Name,
                        orgPermSet.Id
                    );
                }
            }

            //  Return the map at the end
            return this.mapPermissionSetNameToId;
        }
        set;
    }

    //  Mapping UserRole.DeveloperName to UserRole.Id
    private Map<String, Id> mapUserRoleDevNameToId {
        get {
            if (
                this.mapUserRoleDevNameToId == null ||
                this.mapUserRoleDevNameToId.isEmpty()
            ) {
                for (UserRole orgUserRole : [
                    SELECT Id, DeveloperName
                    FROM UserRole
                ]) {
                    this.mapUserRoleDevNameToId.put(
                        orgUserRole.DeveloperName,
                        orgUserRole.Id
                    );
                }
            }

            //  Return the map at the end
            return this.mapUserRoleDevNameToId;
        }
        set;
    }

    /**
     * Nice and simple constructor.
     */
    public TestDataFactoryDto() {
        this.init();
    }

    /**
     * Used to initliase or reset the test record map
     */
    public void init() {
        this.testRecordMap = new Map<String, String>();
    }

    /*  ****************************************  */
    /*          SObject Field Un-Setters          */
    /*  ****************************************  */
    public void unsetKey(String keyName) {
        this.testRecordMap.remove(keyName);
    }

    public void unsetAccountId() {
        this.testRecordMap.remove('AccountId');
        this.testRecordMap.remove('ParentId');
        this.testRecordMap.remove('Account__c');
    }

    /*  ****************************************  */
    /*           SObject Field Setters            */
    /*  ****************************************  */
    /*  Composite Setters                         */
    /*  ****************************************  */
    public void setDefaultFieldsAccount() {
        this.setBillingAddress();
        this.setName();
    }

    public void setDefaultFieldsCampaign() {
        this.setName('TestCampaign');
        this.setStatus('Idea');
        this.setType('Other');
    }

    public void setDefaultFieldsCase() {
        this.setCurrencyIsoCode('EUR');
        this.setOrigin('Email');
        this.setStatus('New Case');
        this.setSubject();
    }

    public void setDefaultFieldsContact() {
        this.setFirstName();
        this.setEmail();
        this.setLastName();
        this.setMailingAddress();
    }

    public void setDefaultFieldsContentDocument() {
        this.setShareTypeI();
        this.setVisibilityAllUsers();
    }

    public void setDefaultFieldsContentVersion() {
        this.setOrigin('H');
        this.setPathOnClient();
        this.setTitle();
        this.setVersionData();
    }

    public void setDefaultFieldsLead() {
        this.setCountry('Australia');
        this.setEmail();
        this.setFirstName();
        this.setLastName();
        this.setLeadSource();
        this.setName(); //  Setting Company name
        this.unsetKey('Name');
    }

    public void setDefaultFieldsOpportunity(String stageName) {
        this.setAmount();
        this.setCloseDate(Date.today());
        this.setCurrencyIsoCode('EUR');
        this.setLeadSource();
        this.setName();
        this.setStage(stageName);
    }

    public void setDefaultUserBase() {
        this.setAlias('Dmaul');
        this.setFirstName('Darth');
        this.setIsActive(true);
        this.testRecordMap.put('EmailEncodingKey', 'UTF-8');
        this.testRecordMap.put('LanguageLocaleKey', 'en_US');
        this.testRecordMap.put('LocaleSidKey', 'de_DE_EURO');
        this.testRecordMap.put('TimeZoneSidKey', 'Europe/Berlin');
    }

    public void setDefaultUserLNameEmail(String lastName) {
        String baseEmail =
            lastName.toLowerCase().replaceAll('[^a-z0-9]', '') + '@example.com';

        this.setEmail(baseEmail);
        this.setLastName(lastName);
        this.setUserName(baseEmail + '.example.com.test');
    }

    /*  ****************************************  */
    /*             Shared Setters                 */
    /*  ****************************************  */
    public void setId(String sobjectId) {
        this.testRecordMap.put('Id', sobjectId);
    }

    public void setAccountId(String accountId) {
        this.testRecordMap.put('AccountId', accountId);
        this.setParentId(accountId);
        this.testRecordMap.put('Account__c', accountId);
    }

    public void setCampaignId(String campaignId) {
        this.testRecordMap.put('CampaignId', campaignId);
    }

    public void setContactId(String contactId) {
        this.testRecordMap.put('ContactId', contactId);
        this.testRecordMap.put('Contact__c', contactId);
    }

    public void setCaseId(String caseId) {
        this.testRecordMap.put('CaseId', caseId);
        this.testRecordMap.put('Case__c', caseId);
    }

    public void setOpportunityId(String oppId) {
        this.testRecordMap.put('OpportunityId', oppId);
        this.testRecordMap.put('Opportunity__c', oppId);
    }

    public void setName() {
        this.setName('Test Record');
    }

    public void setName(String accName) {
        this.testRecordMap.put('Name', accName);
        this.testRecordMap.put('Company', accName);
    }

    public void setEmail() {
        this.setEmail(DEFAULT_EMAIL);
    }

    public void setEmail(String customEmail) {
        this.testRecordMap.put('Email', customEmail);
    }

    public void setPhone(String phone) {
        this.testRecordMap.put('Phone', phone);
    }

    public void setMobilePhone(String mobilePhone) {
        this.testRecordMap.put('MobilePhone', mobilePhone);
    }

    public void setType(String type) {
        this.testRecordMap.put('Type', type);
        this.testRecordMap.put('Type__c', type);
    }

    public void setCurrencyIsoCode(String isoCode) {
        this.testRecordMap.put('CurrencyIsoCode', isoCode);
    }

    public void setFirstName() {
        this.setFirstName(DEFAULT_FIRSTNAME);
    }

    public void setFirstName(String firstName) {
        this.testRecordMap.put('FirstName', firstName);
    }

    public void setLastName() {
        this.setLastName(DEFAULT_LASTNAME);
    }

    public void setLastName(String lastName) {
        this.testRecordMap.put('LastName', lastName);
    }

    public void setStatus(String status) {
        this.testRecordMap.put('Status', status);
        this.testRecordMap.put('Status__c', status);
    }

    public void setOwner(String ownerId) {
        this.testRecordMap.put('OwnerId', ownerId);
        this.testRecordMap.put('Owner__c', ownerId);
    }

    public void setIsActive(Boolean isActive) {
        this.testRecordMap.put('IsActive', this.getBoolean(isActive));
    }

    public void setParentId(Id parentId) {
        this.testRecordMap.put('ParentId', parentId);
    }

    public void setUserOrGroupId(Id userOrGroupId) {
        this.testRecordMap.put('UserOrGroupId', userOrGroupId);
    }

    public void setWhoId(String whoId) {
        this.testRecordMap.put('WhoId', whoId);
    }

    public void setBody(String bodyText) {
        this.testRecordMap.put('Body', bodyText);
    }

    /*  ****************************************  */
    /*  Address-Specific Setters                  */
    /*  ****************************************  */
    //  Set Billing Address Fields
    public void setBillingStreet(String billingStreet) {
        this.testRecordMap.put('BillingStreet', billingStreet);
    }

    public void setBillingCity(String billingCity) {
        this.testRecordMap.put('BillingCity', billingCity);
    }

    public void setBillingPostalCode(String billingPostalCode) {
        this.testRecordMap.put('BillingPostalCode', billingPostalCode);
    }

    public void setBillingCountry(String billingCountry) {
        this.testRecordMap.put('BillingCountry', billingCountry);
    }

    public void setBillingCountryCode(String billingCountryCode) {
        this.testRecordMap.put('BillingCountryCode', billingCountryCode);
    }

    //  This is the default Account Address
    public void setBillingAddress() {
        this.setBillingStreet(DEFAULT_STREET);
        this.setBillingCity(DEFAULT_CITY);
        this.setBillingPostalCode(DEFAULT_POSTCODE);
        this.setBillingCountry(DEFAULT_COUNTRY);
    }

    //  Set Mailing Address fields
    public void setMailingStreet(String mailingStreet) {
        this.testRecordMap.put('MailingStreet', mailingStreet);
    }

    public void setMailingCity(String mailingCity) {
        this.testRecordMap.put('MailingCity', mailingCity);
    }

    public void setMailingPostalCode(String mailingPostalCode) {
        this.testRecordMap.put('MailingPostalCode', mailingPostalCode);
    }

    public void setMailingCountry(String mailingCountry) {
        this.testRecordMap.put('MailingCountry', mailingCountry);
    }

    public void setMailingCountryCode(String mailingCountryCode) {
        this.testRecordMap.put('MailingCountryCode', mailingCountryCode);
    }

    //  This is the default Contact Address
    public void setMailingAddress() {
        this.setMailingStreet(DEFAULT_STREET);
        this.setMailingCity(DEFAULT_CITY);
        this.setMailingPostalCode(DEFAULT_POSTCODE);
        this.setMailingCountry(DEFAULT_COUNTRY);
    }

    public void setStreet() {
        this.testRecordMap.put('Street', DEFAULT_STREET);
    }

    public void setCity() {
        this.setCity(DEFAULT_CITY);
    }

    public void setCity(String city) {
        this.testRecordMap.put('City', city);
    }

    public void setPostalCode() {
        this.setPostalCode(DEFAULT_POSTCODE);
    }

    public void setPostalCode(String postalCode) {
        this.testRecordMap.put('PostalCode', postalCode);
    }

    public void setCountry() {
        this.setCountry(DEFAULT_COUNTRY);
    }

    public void setCountry(String country) {
        this.testRecordMap.put('Country', country);
    }

    public void setCountryCode(String countryCode) {
        this.testRecordMap.put('CountryCode', countryCode);
    }

    //  Default Shipping Address
    public void setShippingAddress() {
        this.testRecordMap.put('ShippingStreet', DEFAULT_STREET);
        this.testRecordMap.put('ShippingCity', DEFAULT_CITY);
        this.testRecordMap.put('ShippingPostalCode', DEFAULT_POSTCODE);
        this.testRecordMap.put('ShippingCountry', DEFAULT_COUNTRY);
    }

    /*  ****************************************  */
    /*  Account-Specific Setters                  */
    /*  ****************************************  */

    /*  ****************************************  */
    /*  Case-Specific Setters                     */
    /*  ****************************************  */
    public void setDescription() {
        this.setDescription('Test');
    }

    public void setDescription(String description) {
        this.testRecordMap.put('Description', description);
    }

    public void setOrigin(String origin) {
        this.testRecordMap.put('Origin', origin);
    }

    public void setSubject() {
        this.setSubject('Test Subject');
    }

    public void setSubject(String subject) {
        this.testRecordMap.put('Subject', subject);
    }

    /*  ****************************************  */
    /*  Contact-Specific Setters                  */
    /*  ****************************************  */

    /*  ****************************************  */
    /*  ContentDocumentLink-Specific Setters      */
    /*  ****************************************  */
    public void setLinkedEntityId(String entityId) {
        this.testRecordMap.put('LinkedEntityId', entityId);
    }

    public void setContentDocId(String contentDocId) {
        this.testRecordMap.put('ContentDocumentId', contentDocId);
    }

    public void setShareTypeI() {
        this.setShareType('I');
    }

    public void setShareType(String shareType) {
        this.testRecordMap.put('ShareType', shareType);
    }

    public void setVisibilityAllUsers() {
        this.setVisibility('AllUsers');
    }

    public void setVisibility(String visibility) {
        this.testRecordMap.put('Visibility', visibility);
    }

    /*  ****************************************  */
    /*  ContentVersion-Specific Setters           */
    /*  ****************************************  */
    public void setTitle() {
        this.setTitle(DEFAULT_ATTACHMENT_NAME);
    }

    public void setTitle(String title) {
        this.testRecordMap.put('Title', title);
    }

    public void setPathOnClient() {
        this.setPathOnClient('/' + DEFAULT_ATTACHMENT_NAME + '.txt');
    }

    public void setPathOnClient(String pathOnClient) {
        this.testRecordMap.put('PathOnClient', pathOnClient);
    }

    public void setVersionData() {
        this.testRecordMap.put('VersionData', 'Unit Test ContentVersion Body');
    }

    /*  ****************************************  */
    /*  FeedComment-Specific Setters              */
    /*  ****************************************  */
    public void setCommentBody(String commentBody) {
        this.testRecordMap.put('CommentBody', commentBody);
    }

    public void setFeedItemId(String feedItemId) {
        this.testRecordMap.put('FeedItemId', feedItemId);
    }

    /*  ****************************************  */
    /*  Lead-Specific Setters                     */
    /*  ****************************************  */
    public void setLeadSource() {
        this.setLeadSource('Sales');
    }

    public void setLeadSource(String leadSource) {
        this.testRecordMap.put('LeadSource', leadSource);
    }

    /*  ****************************************  */
    /*  Opportunity-Specific Setters              */
    /*  ****************************************  */
    public void setAmount() {
        this.setAmount(1337);
    }

    public void setAmount(Decimal testAmount) {
        this.testRecordMap.put('Amount', this.getDecimal(testAmount));
    }

    public void setCloseDate(Date closeDate) {
        this.testRecordMap.put('CloseDate', this.getDate(closeDate));
    }

    public void setStage(String stageName) {
        this.testRecordMap.put('StageName', stageName);
    }

    /*  ****************************************  */
    /*  QueueSObject-Specific Setters             */
    /*  ****************************************  */
    public void setQueueId(String queueId) {
        this.testRecordMap.put('QueueId', queueId);
    }

    public void setSObjectType(String sObjectType) {
        this.testRecordMap.put('SobjectType', sObjectType);
    }

    /*  ****************************************  */
    /*  Task-Specific Setters                     */
    /*  ****************************************  */
    public void setTaskSubType(String taskSubType) {
        this.testRecordMap.put('TaskSubtype', taskSubType);
    }

    /*  ****************************************  */
    /*  User-Specific Setters                     */
    /*  ****************************************  */
    public void setAlias(String alias) {
        this.testRecordMap.put('Alias', alias);
    }

    public void setManagerId(String managerId) {
        this.testRecordMap.put('ManagerId', managerId);
    }

    public void setProfile(String profileName) {
        this.testRecordMap.put(
            'ProfileId',
            this.queryProfileIdByName(profileName)
        );
    }

    public void setProfileSysAdmin() {
        this.setProfile('System Administrator');
    }

    public void setUserName(String userName) {
        this.testRecordMap.put('Username', userName);
    }

    public void setUserRole(String roleDevName) {
        this.testRecordMap.put(
            'UserRoleId',
            this.queryUserRoleIdByDevName(roleDevName)
        );
    }

    /**
     * Build the test record as an SObject that is initialised as the target object.
     * Example for passing Schema.SObjectType: buildTestRecord(Account.getSObjectType(), testAccData);
     * @param   Schema.SObjectType. The target result SObject to be created
     * @param   Map<String, String>. The key/value pairs of field names and values for the record
     * @return  SObject.
     */
    public SObject buildTestRecord(
        Schema.SObjectType testRecType,
        Map<String, String> testData
    ) {
        SObject testRec = testRecType.newSObject();
        String testRecTypeString = testRecType.getDescribe().getName();
        List<Schema.SObjectField> sObjFields = testRecType.getDescribe()
            .fields.getMap()
            .values();

        for (Schema.SObjectField sObjField : sObjFields) {
            String fieldName = sObjField.getDescribe().getName();

            //  Some standard SObjects have an unwriteable Name field
            if (
                !this.testRecordMap.containsKey(fieldName) ||
                (UNWRITEABLE_NAME.contains(testRecTypeString) &&
                fieldName == 'Name') ||
                sObjField.getDescribe().isCalculated()
            ) {
                continue;
            }

            //  Get field type, and put(key, value-with-type)
            String fType = String.valueOf(sObjField.getDescribe().getType());
            String fieldData = testData.get(fieldName);
            if (fieldData == null) {
                testRec.put(fieldName, fieldData);
            } else {
                if (fType == 'Boolean') {
                    testRec.put(fieldName, Boolean.valueOf(fieldData));
                } else if (fType == 'Date') {
                    testRec.put(fieldName, Date.valueOf(fieldData));
                } else if (fType == 'DateTime') {
                    testRec.put(fieldName, DateTime.valueOf(fieldData));
                } else if (DECIMAL_TYPES.contains(fType)) {
                    testRec.put(fieldName, Decimal.valueOf(fieldData));
                } else if (BLOB_FIELDS.contains(fieldName)) {
                    testRec.put(fieldName, Blob.valueOf(fieldData));
                } else {
                    testRec.put(fieldName, fieldData);
                }
            }
        }

        return testRec;
    }

    /*  ****************************************  */
    /*               SObject Getters              */
    /*  ****************************************  */
    /**
     * Builds and returns a test Account record
     * @return  Account
     */
    public Account getAccount() {
        Account testRec = (Account) buildTestRecord(
            Account.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test Campaign record
     * @return  Campaign
     */
    public Campaign getCampaign() {
        Campaign testRec = (Campaign) buildTestRecord(
            Campaign.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test CampaignMember record
     * @return  CampaignMember
     */
    public CampaignMember getCampaignMember() {
        CampaignMember testRec = (CampaignMember) buildTestRecord(
            CampaignMember.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test Case record
     * @return  Case
     */
    public Case getCase() {
        Case testRec = (Case) buildTestRecord(
            Case.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test Contact record
     * @return  Contact
     */
    public Contact getContact() {
        Contact testRec = (Contact) buildTestRecord(
            Contact.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test ContentDocumentLink record
     * @return  ContentDocumentLink
     */
    public ContentDocumentLink getContentDocumentLink() {
        ContentDocumentLink testRec = (ContentDocumentLink) buildTestRecord(
            ContentDocumentLink.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test ContentVersion record
     * @return  ContentVersion
     */
    public ContentVersion getContentVersion() {
        ContentVersion testRec = (ContentVersion) buildTestRecord(
            ContentVersion.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test FeedComment record
     * @return  FeedComment
     */
    public FeedComment getFeedComment() {
        FeedComment testRec = (FeedComment) buildTestRecord(
            FeedComment.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test FeedItem record
     * @return  FeedItem
     */
    public FeedItem getFeedItem() {
        FeedItem testRec = (FeedItem) buildTestRecord(
            FeedItem.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test Group record
     * @return  Group
     */
    public Group getGroup() {
        Group testRec = (Group) buildTestRecord(
            Group.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test Lead record
     * @return  Lead
     */
    public Lead getLead() {
        //  Name is not writeable on Lead
        if (this.testRecordMap.keySet().contains('Name')) {
            this.testRecordMap.remove('Name');
        }

        Lead testRec = (Lead) buildTestRecord(
            Lead.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test Opportunity record
     * @return  Opportunity
     */
    public Opportunity getOpportunity() {
        Opportunity testRec = (Opportunity) buildTestRecord(
            Opportunity.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test OpportunityLineItem record
     * @return  OpportunityLineItem
     */
    public OpportunityLineItem getOpportunityLineItem() {
        OpportunityLineItem testRec = (OpportunityLineItem) buildTestRecord(
            OpportunityLineItem.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test QueueSObject record
     * @return  QueueSObject
     */
    public QueueSObject getQueueSObject() {
        QueueSObject testRec = (QueueSObject) buildTestRecord(
            QueueSObject.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test Task record
     * @return  Task
     */
    public Task getTask() {
        Task testRec = (Task) buildTestRecord(
            Task.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /**
     * Builds and returns a test User record
     * @return  User
     */
    public User getUser() {
        User testRec = (User) buildTestRecord(
            User.getSObjectType(),
            this.testRecordMap
        );

        return testRec;
    }

    /*  ****************************************  */
    /*           Query User-Related Ids           */
    /*  ****************************************  */
    /**
     * Return a Profile.Id for a specific Profile.Name value
     * @param   String. Profile name
     * @return  Id
     */
    private Id queryProfileIdByName(String profileName) {
        return this.mapProfileNameToId.get(profileName);
    }

    /**
     * Return a PermissionSet.Id for a specific PermissionSet.Name value
     * @param   String. PermissionSet name
     * @return  Id
     */
    private Id queryPermissionSetIdByName(String permSetName) {
        return this.mapPermissionSetNameToId.get(permSetName);
    }

    /**
     * Return a UserRole.Id for a specific UserRole.DeveloperName value
     * @param   String. DeveloperName of UserRole
     * @return  Id
     */
    private Id queryUserRoleIdByDevName(String devName) {
        return this.mapUserRoleDevNameToId.get(devName);
    }

    /*  ****************************************  */
    /*            Primitive Sanitising            */
    /*  ****************************************  */
    /**
     * Yes, this is wild, but Booleans can be null in Apex
     */
    private String getBoolean(Boolean booleanValue) {
        return booleanValue == null ? null : String.valueOf(booleanValue);
    }

    private String getDecimal(Decimal decimalValue) {
        return decimalValue == null ? null : String.valueOf(decimalValue);
    }

    private String getDate(Date dateValue) {
        return dateValue == null
            ? null
            : ((DateTime) dateValue).format('yyyy-MM-dd');
    }

    private String getDateTime(DateTime dateTimeValue) {
        return dateTimeValue == null ? null : String.valueOf(dateTimeValue);
    }

    private String getInteger(Integer intValue) {
        return intValue == null ? null : String.valueOf(intValue);
    }
}