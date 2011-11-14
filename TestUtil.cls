/*
Maintained by @fracastical
Made possible by @ReidCarlberg
*/

public with sharing class TestUtil {

	/*
		A random user is useful for testing in order to be 
		sure that you are able to see data across posts regardless
		of follow status.
	*/  
	public static User createTestUser() {
		Profile p = [Select Id, Name from Profile where Name = 'System Administrator' OR Name = 'Systemadministrator' ];
		return TestUtil.createTestUser(p);
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
    	
    	System.assert(TestUtil.createRandomWord() != TestUtil.createRandomWord());
    }
    
	static TestMethod void testCreateUser() {

		User u = TestUtil.createTestUser();

		System.assert(u.id != null);

	}



}
