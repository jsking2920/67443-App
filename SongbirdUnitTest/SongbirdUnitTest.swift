//
//  SongbirdUnitTest.swift
//  SongbirdUnitTest
//
//  Created by Ahsan on 08/12/2022.
//

import XCTest
@testable import Songbird

class SongbirdUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

  func testExample() async throws {  // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.
      // Any test you write for XCTest can be annotated as throws and async.
      // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
      // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
      let dailySongTest = DailySong(spotify_id: "1", artist: "Freddie Mercury", title: "Love of my life")
      let dailySongTest2 = DailySong(spotify_id: "2", artist: "calvin harris", title:"abc")
      
      
      let testUser = User(id: "UUID" , email: "test@gmail.com", daily_songs: ["1":dailySongTest,"2":dailySongTest2] )

      XCTAssertEqual(testUser.id, "UUID");
      XCTAssertEqual(testUser.email, "test@gmail.com");
      try await UserCollectionTest()

    
//      let testUser = User(id: "UUID", email: "", daily_songs: Dictionary<String, DailySongTest> )
//      XCTAssertNil(testUser.email, "No email inserted")
    
  }
  
    func UserCollectionTest() async throws {
        //account for errors


      let dailySongTest = DailySong(spotify_id: "1", artist: "Freddie Mercury", title: "Love of my life")
      let dailySongTest2 = DailySong(spotify_id: "2", artist: "calvin harris", title:"abc")
    
    
      let testUser = User(id: "UUID" , email: "test@gmail.com", daily_songs: ["1":dailySongTest,"2":dailySongTest2] )
      
      let wrongUser:User = User(id: "UUID" , email: "", daily_songs: ["1":dailySongTest,"2":dailySongTest2] )

      //testing the get method
      let testUserCollection: UserCollection = UserCollection();
      var userCollections: Int = testUserCollection.users.count;
      
      
      XCTAssertEqual(userCollections, 0)
//
//
//      //testing add method
      let testUser2 = User(id: "UUID2", email: "", daily_songs: ["1":dailySongTest,"2":dailySongTest2] )
      await testUserCollection.add(testUser2)
//      wait(for:20.seconds, timeout: 1.seconds)
      await testUserCollection.get()
      print(testUserCollection.users)
      
      print(testUserCollection.users.count)
      print(testUserCollection.users)
      
//      XCTAssertNoThrow(testUserCollection.add(wrongUser))
      
//      XCTAssertEqual(testUserCollection.users.count, 1)
      
//
//      let testUser2 = User(id: "UUID2", email: "test2@gmail.com", daily_songs: Dictionary<String, DailySongTest> )
//      testUserCollection.add(user: testUser2)
//      XCTAssertEqual(testUserCollection.count -> 2)
//
//
      var testUser3 = User(id: "UUID3", email: "test3@gmail.com", daily_songs: ["1":dailySongTest,"2":dailySongTest2] )
      await testUserCollection.add(testUser3)
      let beforeUpdate:User = testUserCollection.users.last ?? testUser3
      testUser3 = User(id: "UUID3", email: "test4@gmail.com", daily_songs: ["1":dailySongTest,"2":dailySongTest2] )
      testUserCollection.update(testUser3)
      let afterUpdate = testUserCollection.users.last
      XCTAssertEqual(beforeUpdate, afterUpdate)
//
//      testUserCollection.remove(user: testUser1)
//      XCTAssertEqual(testUserCollection.count -> 1)



      
    }

  

}
