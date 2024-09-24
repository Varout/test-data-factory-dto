/**
 * Used to create records to be used in unit tests.
 * @see Class: TestDataFactoryDto.cls - Used as a Data Transfer Object to create test data
 * @see Class: TestDataFactoryHelper.cls - Contains commonly used functions
 */
@isTest
public class TestDataFactory {
    //  Containers for test records
    private List<Account> testAccounts = new List<Account>();
    private List<Case> testCases = new List<Case>();
    private List<Campaign> testCampaigns = new List<Campaign>();
    private List<CampaignMember> testCampaignMembers = new List<CampaignMember>();
    private List<Contact> testContacts = new List<Contact>();
    private List<ContentDocumentLink> testContentDocumentLinks = new List<ContentDocumentLink>();
    private List<ContentVersion> testContentVersions = new List<ContentVersion>();
    private List<FeedComment> testFeedComments = new List<FeedComment>();
    private List<FeedItem> testFeedItems = new List<FeedItem>();
    private List<Group> testGroups = new List<Group>();
    private List<Lead> testLeads = new List<Lead>();
    private List<Opportunity> testOpportunities = new List<Opportunity>();
    private List<OpportunityLineItem> testOpportunityLineItems = new List<OpportunityLineItem>();
    private List<QueueSObject> testQueueSObjects = new List<QueueSObject>();
    private List<Task> testTasks = new List<Task>();
    private List<User> testUsers = new List<User>();

    public TestDataFactory() {
        this.init();
    }

    /*  ****************************************  */
    /*          Dedicated List Getters            */
    /*  ****************************************  */
    public List<Account> getAccounts() {
        return this.testAccounts;
    }

    public List<Campaign> getCampaigns() {
        return this.testCampaigns;
    }

    public List<CampaignMember> getCampaignMembers() {
        return this.testCampaignMembers;
    }

    public List<Case> getCases() {
        return this.testCases;
    }

    public List<Contact> getContacts() {
        return this.testContacts;
    }

    public List<FeedComment> getFeedComments() {
        return this.testFeedComments;
    }

    public List<FeedItem> getFeedItems() {
        return this.testFeedItems;
    }

    public List<Group> getGroups() {
        return this.testGroups;
    }

    public List<Lead> getLeads() {
        return this.testLeads;
    }

    public List<Opportunity> getOpportunities() {
        return this.testOpportunities;
    }

    public List<OpportunityLineItem> getOpportunityLineItems() {
        return this.testOpportunityLineItems;
    }

    public List<QueueSObject> getQueueSObjects() {
        return this.testQueueSObjects;
    }

    public List<Task> getTasks() {
        return this.testTasks;
    }

    public List<User> getUsers() {
        return this.testUsers;
    }

    /*  ****************************************  */
    /*                  DTO Setup                 */
    /*  ****************************************  */
    public TestDataFactoryDto dto = new TestDataFactoryDto();
    public TestDataFactoryDto init() {
        this.testAccounts.clear();
        this.testCampaigns.clear();
        this.testCampaignMembers.clear();
        this.testCases.clear();
        this.testContacts.clear();
        this.testFeedComments.clear();
        this.testFeedItems.clear();
        this.testGroups.clear();
        this.testLeads.clear();
        this.testOpportunities.clear();
        this.testOpportunityLineItems.clear();
        this.testQueueSObjects.clear();
        this.testTasks.clear();
        this.testUsers.clear();

        //  Re-initialise Dto
        this.dto.init();

        return this.dto;
    }

    /*  ****************************************  */
    /*                  General                   */
    /*  ****************************************  */
    /**
     * Creates a fake record Id for an SObject of length 18.
     * e.g. getFakeSObjectId(Account.getSObjectType())
     * @param   SObjectType
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

    /*  ****************************************  */
    /*                  Account                   */
    /*  ****************************************  */
    /**
     * Gets an Account from the DTO, adds it to the list of Accounts,
     * returns the Account record.
     * @param   Boolean. If insert
     * @return  Account
     */
    public Account createAccount(Boolean doInsert) {
        Account testAcc = dto.getAccount();

        this.testAccounts.add(testAcc);

        if (doInsert) {
            insert testAcc;
        }
        return testAcc;
    }

    /*  ****************************************  */
    /*                  Campaign                  */
    /*  ****************************************  */
    /**
     * Gets a Campaign from the DTO, adds it to the list of Campaigns,
     * returns the Campaign record.
     * @param   Boolean. If insert
     * @return  Campaign
     */
    public Campaign createCampaign(Boolean doInsert) {
        Campaign testCampaign = dto.getCampaign();

        this.testCampaigns.add(testCampaign);

        if (doInsert) {
            insert testCampaign;
        }
        return testCampaign;
    }

    /*  ****************************************  */
    /*                  Campaign Member           */
    /*  ****************************************  */
    /**
     * Gets a CampaignMember from the DTO, adds it to the list of CampaignMembers,
     * returns the CampaignMember record.
     * @param   Boolean. If insert
     * @return  CampaignMember
     */
    public CampaignMember createCampaignMember(Boolean doInsert) {
        CampaignMember testCampaignMember = dto.getCampaignMember();

        this.testCampaignMembers.add(testCampaignMember);

        if (doInsert) {
            insert testCampaignMember;
        }
        return testCampaignMember;
    }

    /*  ****************************************  */
    /*                  Case                      */
    /*  ****************************************  */
    /**
     * Gets a Case from the DTO, adds it to the list of Case,
     * returns the Case record.
     * @param   Boolean. If insert
     * @return  Case
     */
    public Case createCase(Boolean doInsert) {
        Case testCase = dto.getCase();

        this.testCases.add(testCase);

        if (doInsert) {
            insert testCase;
        }
        return testCase;
    }

    /*  ****************************************  */
    /*                  Contact                   */
    /*  ****************************************  */
    /**
     * Gets a Contact from the DTO, adds it to the list of Contacts,
     * returns the Contact record.
     * @param   Boolean. If insert
     * @return  Contact
     */
    public Contact createContact(Boolean doInsert) {
        Contact testContact = dto.getContact();

        this.testContacts.add(testContact);

        if (doInsert) {
            insert testContact;
        }
        return testContact;
    }

    /*  ****************************************  */
    /*                  ContentDocumentLink                   */
    /*  ****************************************  */
    /**
     * Gets a ContentDocumentLink from the DTO, adds it to the list of ContentDocumentLinks,
     * returns the ContentDocumentLink record.
     * @param   Boolean. If insert
     * @return  ContentDocumentLink
     */
    public ContentDocumentLink createContentDocumentLink(Boolean doInsert) {
        ContentDocumentLink testContentDocumentLink = dto.getContentDocumentLink();

        this.testContentDocumentLinks.add(testContentDocumentLink);

        if (doInsert) {
            insert testContentDocumentLink;
        }
        return testContentDocumentLink;
    }

    /*  ****************************************  */
    /*                  ContentVersion                   */
    /*  ****************************************  */
    /**
     * Gets a ContentVersion from the DTO, adds it to the list of ContentVersions,
     * returns the ContentVersion record.
     * @param   Boolean. If insert
     * @return  ContentVersion
     */
    public ContentVersion createContentVersion(Boolean doInsert) {
        ContentVersion testContentVersion = dto.getContentVersion();

        this.testContentVersions.add(testContentVersion);

        if (doInsert) {
            insert testContentVersion;
        }
        return testContentVersion;
    }

    /*  ****************************************  */
    /*                  FeedComment                   */
    /*  ****************************************  */
    /**
     * Gets a FeedComment from the DTO, adds it to the list of FeedComments,
     * returns the FeedComment record.
     * @param   Boolean. If insert
     * @return  FeedComment
     */
    public FeedComment createFeedComment(Boolean doInsert) {
        FeedComment testFeedCommentn = dto.getFeedComment();

        this.testFeedComments.add(testFeedCommentn);

        if (doInsert) {
            insert testFeedCommentn;
        }
        return testFeedCommentn;
    }

    /*  ****************************************  */
    /*                  FeedItem                   */
    /*  ****************************************  */
    /**
     * Gets a FeedItem from the DTO, adds it to the list of FeedItems,
     * returns the FeedItem record.
     * @param   Boolean. If insert
     * @return  FeedItem
     */
    public FeedItem createFeedItem(Boolean doInsert) {
        FeedItem testFeedItem = dto.getFeedItem();

        this.testFeedItems.add(testFeedItem);

        if (doInsert) {
            insert testFeedItem;
        }
        return testFeedItem;
    }

    /*  ****************************************  */
    /*                  Group                   */
    /*  ****************************************  */
    /**
     * Gets a Group from the DTO, adds it to the list of Groups,
     * returns the Group record.
     * @param   Boolean. If insert
     * @return  Group
     */
    public Group createGroup(Boolean doInsert) {
        Group testGroup = dto.getGroup();

        this.testGroups.add(testGroup);

        if (doInsert) {
            insert testGroup;
        }
        return testGroup;
    }

    /*  ****************************************  */
    /*                  Lead                      */
    /*  ****************************************  */
    /**
     * Gets a Lead from the DTO, adds it to the list of Leads,
     * returns the Lead record.
     * @param   Boolean. If insert
     * @return  Lead
     */
    public Lead createLead(Boolean doInsert) {
        Lead testLead = dto.getLead();

        this.testLeads.add(testLead);

        if (doINsert) {
            insert testLead;
        }
        return testLead;
    }

    /*  ****************************************  */
    /*                  Opportunity               */
    /*  ****************************************  */
    /**
     * Gets an Opportunity from the DTO, adds it to the list of Opportunities,
     * returns the Opportunity record.
     * @param   Boolean. If insert
     * @return  Opportunity
     */
    public Opportunity createOpportunity(Boolean doInsert) {
        Opportunity testOpp = dto.getOpportunity();

        this.testOpportunities.add(testOpp);

        if (doInsert) {
            insert testOpp;
        }
        return testOpp;
    }

    /*  ****************************************  */
    /*                  OpportunityLineItem               */
    /*  ****************************************  */
    /**
     * Gets an OpportunityLineItem from the DTO, adds it to the list of OpportunityLineItems,
     * returns the OpportunityLineItem record.
     * @param   Boolean. If insert
     * @return  OpportunityLineItem
     */
    public OpportunityLineItem createOpportunityLineItem(Boolean doInsert) {
        OpportunityLineItem testOppLineItem = dto.getOpportunityLineItem();

        this.testOpportunityLineItems.add(testOppLineItem);

        if (doInsert) {
            insert testOppLineItem;
        }
        return testOppLineItem;
    }

    /*  ****************************************  */
    /*                  QueueSObject               */
    /*  ****************************************  */
    /**
     * Gets an QueueSObject from the DTO, adds it to the list of QueueSObjects,
     * returns the QueueSObject record.
     * @param   Boolean. If insert
     * @return  QueueSObject
     */
    public QueueSObject createQueueSObject(Boolean doInsert) {
        QueueSObject testQueueSObject = dto.getQueueSObject();

        this.testQueueSObjects.add(testQueueSObject);

        if (doInsert) {
            insert testQueueSObject;
        }
        return testQueueSObject;
    }

    /*  ****************************************  */
    /*                  Task                      */
    /*  ****************************************  */
    /**
     * Gets a Task from the DTO, adds it to the list of Tasks,
     * returns the User record.
     * @param   Boolean. If insert
     * @return  Task
     */
    public Task createTask(Boolean doInsert) {
        Task testTask = dto.getTask();

        this.testTasks.add(testTask);

        if (doInsert) {
            insert testTask;
        }
        return testTask;
    }

    /*  ****************************************  */
    /*                  User                      */
    /*  ****************************************  */
    /**
     * Gets a User from the DTO, adds it to the list of Users,
     * returns the User record.
     * @param   Boolean. If insert
     * @return  User
     */
    public User createUser(Boolean doInsert) {
        User testUser = dto.getUser();

        this.testUsers.add(testUser);

        if (doInsert) {
            insert testUser;
        }
        return testUser;
    }
}