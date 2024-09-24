# Test Data Factory: Data Transfer Object

Developed to clean up messy test classes and streamline test data creation, whether to be inserted or not.

Last tested with API version: `61.0`

## Classes

### TestDataFactory.cls

Used to create and retrieve your test data on an SObject-by-SObject basis.

#### Initialise

```Java
TestDataFactory tdf = new TestDataFactory();
```

#### Creating test data: One record at a time (Account)

```Java
//  Insert record
tdf.createAccount(true);

//  Insert record and return
Account testAcc = tdf.createAccount(true);

//  Create and return record without insert
Account testAcc = tdf.createAccount(false);
```

#### Creating test data: Bulk (Account)

```Java
//  Insert multiple records that have been created without insert
insert tdf.getAccounts();
//  Insert multiple records that have been created without insert from a list
List<Account> testAccounts = tdf.getAccounts();
insert testAccounts;
```

#### Out of the Box Supported SObjects

- Account
- Campaign
- CampaignMember
- Case
- Contact
- FeedComment
- FeedItem
- Group
- Lead
- Opportunity
- OpportunityLineItem
- QueueSObject
- Task
- User

### TestDataFactoryDto.cls

Used to populate test data fields. Has default values for:

- FirstName
- LastName
- Email
- Attachment
- Address: Street
- Address: City
- Address: PostCode
- Address: Country

These values are used for values in the composite setters.

#### Initialise

```Java
TestDataFactory tdf = new TestDataFactory();
TestDataFactoryDto dto = tdf.dto;
```

#### Create Data For Fields Using Composite Setters

**Account**

```Java
//  Sets Name and BillingAddress fields
dto.setDefaultFieldsAccount();
//  Insert and return Account
Account testAccount = tdf.createAccount(true);
```

**User**

```Java
//  Sets Alias, FirstName, IsActive, EmailEncodingKey, LanguageLocaleKey, LocaleSidKey, TimeZoneSidKeyd
dto.setsetDefaultUserBase();
//  Sets Email, LastName, UserName based on the string passed. Salitises the string for Email
dto.setDefaultUserLNameEmail(lastName);
//  Set Profile as "System Administrator"
dto.setProfileSysAdmin();
//  Insert User, and return User.Id
Id testUserId = tdf.createUser(true).Id;
```

#### Create Data for Fields Using Multiple Setters

**Account**

```Java
//  Set the Name
dto.setName('TestAccount');
//  Set the Billing Address fields
// dto.setBillingAddress();
dto.setBillingString(billingStreet);
dto.setBillingCity(billingCity);
dto.setBilllingPostalCode(billingPostalCode);
dto.setBillingCountry(billingCountry);
...
```

**User**

```Java
//  Sets Alias, FirstName, IsActive, EmailEncodingKey, LanguageLocaleKey, LocaleSidKey, TimeZoneSidKeyd
dto.setsetDefaultUserBase();
//  Sets Email, LastName, UserName based on the string passed. Salitises the string for Email
dto.setDefaultUserLNameEmail(lastName);
//  Override set Email Address
dto.setEmail('use_this_email@example.com');
//  Set Profile
dto.setProfile(<Profile.Name>);
...
```

The setters are designed to accept the same primative type that the field is in Salesforce.
e.g.

```Java
//  setAmount expects a Decimal
dto.setAmount(4.2);
//  setCloseData expects a Date
dto.setCloseDate(Date.today().addMonths(1));
//  setIsActive expects a Boolean
dto.setIsActive(true);
```

There are no included fields which require a DateTime that are included, however the ability to pass it is available. See the bottom of the class.

### TestDataFactoryHelper.cls

Contains misc useful functions and static vars for testing.
