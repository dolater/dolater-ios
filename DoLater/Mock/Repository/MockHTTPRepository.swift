//
//  MockHTTPRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import Foundation

final actor MockHTTPRepository: HTTPRepositoryProtocol {
    func get(for url: URL) async throws -> Data {
        switch url.absoluteString {
        case "https://developer.apple.com/documentation/swiftui":
            return """
            <!DOCTYPE html><html lang="en-US"><head><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><link rel="icon" href="/favicon.ico"><link rel="mask-icon" href="/apple-logo.svg" color="#333333"><title>SwiftUI | Apple Developer Documentation</title><script>var baseUrl = "/tutorials/"</script><link rel="stylesheet" href="https://www.apple.com/wss/fonts?families=SF+Pro,v3|SF+Mono,v1|SF+Pro+SC,v1|SF+Pro+JP,v1" referrerpolicy="origin-when-cross-origin"><script defer="defer" src="/tutorials/js/chunk-vendors.c920d962.js"></script><script defer="defer" src="/tutorials/js/chunk-common.9cbebaf5.js"></script><script defer="defer" src="/tutorials/js/index.5292d3cf.js"></script><link href="/tutorials/css/chunk-vendors.919160e0.css" rel="stylesheet"><link href="/tutorials/css/index.a39f9fa2.css" rel="stylesheet"><meta name="description" content="Declare the user interface and behavior for your app on every platform."><meta property="og:locale" content="en_US"><meta property="og:site_name" content="Apple Developer Documentation"><meta property="og:type" content="website"><meta property="og:image" content="https://docs.developer.apple.com/tutorials/developer-og.jpg"><meta property="og:title" content="SwiftUI | Apple Developer Documentation"><meta property="og:description" content="Declare the user interface and behavior for your app on every platform."><meta property="og:url" content="https://docs.developer.apple.com/documentation/swiftui"><meta name="twitter:card" content="summary_large_image"><meta name="twitter:image" content="https://docs.developer.apple.com/tutorials/developer-og-twitter.jpg"><meta name="twitter:description" content="Declare the user interface and behavior for your app on every platform."><meta name="twitter:title" content="SwiftUI | Apple Developer Documentation"><meta name="twitter:url" content="https://docs.developer.apple.com/documentation/swiftui"></head><body data-color-scheme="auto"><div id="_omniture_top"><script>var s_account="awdappledeveloper"</script><script src="/tutorials/js/analytics.js"></script></div><noscript><style>.noscript{font-family:"SF Pro Display","SF Pro Icons","Helvetica Neue",Helvetica,Arial,sans-serif;margin:92px auto 140px auto;text-align:center;width:980px}.noscript-title{color:#111;font-size:48px;font-weight:600;letter-spacing:-.003em;line-height:1.08365;margin:0 auto 54px auto;width:502px}@media only screen and (max-width:1068px){.noscript{margin:90px auto 120px auto;width:692px}.noscript-title{font-size:40px;letter-spacing:0;line-height:1.1;margin:0 auto 45px auto;width:420px}}@media only screen and (max-width:735px){.noscript{margin:45px auto 60px auto;width:87.5%}.noscript-title{font-size:32px;letter-spacing:.004em;line-height:1.125;margin:0 auto 35px auto;max-width:330px;width:auto}}#loading-placeholder{display:none}</style><div class="noscript"><h1 class="noscript-title">This page requires JavaScript.</h1><p>Please turn on JavaScript in your browser and refresh the page to view its content.</p></div></noscript><div id="app"></div></body></html>
            """.data(using: .utf8)!
        default:
            return Data()
        }
    }
}
