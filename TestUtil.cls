/*
Props to: reid.carlberg@salesforce.com
*/

public with sharing class TestUtility {

	/*
		A random user is useful for testing in order to be 
		sure that you are able to see data across posts regardless
		of follow status.
	*/  
	public static User createTestUser() {
		Profile p = [Select Id, Name from Profile where Name = 'System Administrator'];
		return TestUtility.createTestUser(p);
	}

	public static User createTestUser(Profile p) {

		String namePrefix = createRandomWord();

		AggregateResult[] userCount = [Select count(id) userCount From user where username like :namePrefix];

		Object users = userCount[0].get('userCount');

		User testUser = new User();
		testUser.Email = 'test@test.com';
		testUser.Username = namePrefix+users+'@testuser.com';

		testUser.LastName = 'test';
		testUser.Alias = 'test';
		testUser.ProfileId = p.Id;
		testUser.LanguageLocaleKey = 'en_US';
		testUser.LocaleSidKey = 'en_US';
		testUser.TimeZoneSidKey = 'America/Chicago';
		testUser.EmailEncodingKey = 'UTF-8';
		insert testUser;
		return testUser;
	}

	public static FeedPost createFeedPost(Id parentId, String title, String body) {
		FeedPost fp = new FeedPost();
		fp.ParentId = parentId;
		fp.Title = title;
		fp.Body = body;
		insert fp;

		return fp;

    }
    
    
    /*
    	Random words are required for testing 
    	as you will likely run into any word I can insert
    	during a test class and produce false test results.
    */
    	
    public static String createRandomWord() {
    	
    	String ret = 'word' + math.rint(math.random() * 100000);
    	
    	return ret;
    	
    }
    
    //TEST METHODS
    
    static TestMethod void testRandomWord() {
    	
    	System.assert(TestUtility.createRandomWord() != TestUtility.createRandomWord());
    }
    
	static TestMethod void testCreateUser() {

		User u = TestUtility.createTestUser();

		System.assert(u.id != null);

	}

	static TestMethod void testCreateFeedPost() {

		User u = TestUtility.createTestUser();

		FeedPost p = TestUtility.createFeedPost(u.id, 'title', 'body');

		System.assert(p.id != null);
	}

	/* 
    Test methods and utilities
    */
    
    
  /*  public static void addSingleKeyword(String kw) {
        Chatter_Keywords__c kw1 = new Chatter_Keywords__c();
        kw1.Name = kw;
        insert kw1;
    }*/

}
