import XCTest
@testable import WebAuthentication

class AuthConfigurationTests: XCTestCase {

    func testInitializationWithAllParameters() {
        let config = AuthConfiguration(
            authCallbackURLScheme: "myapp",
            authCallbackTokenQueryParamName: "token",
            authStatusChangedNotificationName: Notification.Name("AuthChanged"),
            authStatusChangedNotificationInfo: "tokenKey",
            ephemeralWebSession: true
        )

        XCTAssertEqual(config.authCallbackURLScheme, "myapp")
        XCTAssertEqual(config.authCallbackTokenQueryParamName, "token")
        XCTAssertEqual(config.authStatusChangedNotificationName, Notification.Name("AuthChanged"))
        XCTAssertEqual(config.authStatusChangedNotificationInfo, "tokenKey")
        XCTAssertTrue(config.ephemeralWebSession)
    }

    func testEphemeralWebSessionDefaultsFalse() {
        let config = AuthConfiguration(
            authCallbackURLScheme: "myapp",
            authCallbackTokenQueryParamName: "token",
            authStatusChangedNotificationName: Notification.Name("AuthChanged"),
            authStatusChangedNotificationInfo: "tokenKey"
        )

        XCTAssertFalse(config.ephemeralWebSession)
    }
}

class WebAuthenticationResultTests: XCTestCase {

    func testTokenResult() {
        let result = WebAuthenticationResult.token("abc123")

        if case let .token(token) = result {
            XCTAssertEqual(token, "abc123")
        } else {
            XCTFail("Expected .token case")
        }
    }

    func testOtherCallbackResult() {
        let url = URL(string: "myapp://callback")!
        let result = WebAuthenticationResult.otherCallback(url)

        if case let .otherCallback(callbackURL) = result {
            XCTAssertEqual(callbackURL, url)
        } else {
            XCTFail("Expected .otherCallback case")
        }
    }
}

class WebAuthenticationErrorTests: XCTestCase {

    func testUserCancelledError() {
        let error = WebAuthenticationError.userCancelled
        if case .userCancelled = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .userCancelled case")
        }
    }

    func testPresentationError() {
        let error = WebAuthenticationError.presentationError
        if case .presentationError = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .presentationError case")
        }
    }

    func testUnknownError() {
        let error = WebAuthenticationError.unknownError
        if case .unknownError = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .unknownError case")
        }
    }

    func testWrappedError() {
        let underlying = NSError(domain: "test", code: 42)
        let error = WebAuthenticationError.webAuthenticationError(underlying)

        if case let .webAuthenticationError(wrapped) = error {
            XCTAssertEqual((wrapped as NSError).code, 42)
        } else {
            XCTFail("Expected .webAuthenticationError case")
        }
    }
}

class WebAuthenticationTests: XCTestCase {

    func testInitialization() {
        let config = AuthConfiguration(
            authCallbackURLScheme: "myapp",
            authCallbackTokenQueryParamName: "token",
            authStatusChangedNotificationName: Notification.Name("AuthChanged"),
            authStatusChangedNotificationInfo: "tokenKey"
        )

        let auth = WebAuthentication(configuration: config)
        XCTAssertNotNil(auth)
    }
}
