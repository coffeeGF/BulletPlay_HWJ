
Pod::Spec.new do |s|

  s.name         = "ASIHTTPRequest"
  s.version      = "0.0.1"
  s.summary      = "one old version ASIHTTPRequest for my app."
  s.homepage     = "http://wenxp/ASIHTTPRequest"
  s.author             = { "wenxp" => "wenxp2006@qq.com" }
   s.license      = 'WenXP License'
  s.source       = { :git => "https://github.com/wenxp/ASIHTTPRequest.git", :tag => "0.0.1" }

  s.description  = <<-DESC
                   A longer description of ASIHTTPRequest in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

 s.requires_arc = false
 s.subspec 'Core' do |core|
    core.source_files = 'Classes/*.{h,m}'
    core.ios.dependency 'Reachability' #, '~> 2.0', '>= 2.0.4'
    core.ios.frameworks   = 'MobileCoreServices', 'CFNetwork', 'CoreGraphics'

    core.osx.exclude_files = '**/*ASIAuthenticationDialog*'
    core.osx.frameworks   = 'SystemConfiguration', 'CoreServices'

    core.libraries = 'z.1'
  end

  s.subspec 'ASIWebPageRequest' do |ws|
    ws.source_files = 'Classes/ASIWebPageRequest/*.{h,m}'
    ws.libraries      = 'xml2.2'
    ws.xcconfig     = { 'HEADER_SEARCH_PATHS' => '"$(SDKROOT)/usr/include/libxml2"' }
    ws.dependency 'ASIHTTPRequest/Core'
    ws.requires_arc = false
  end

  s.subspec 'CloudFiles' do |cfs|
    cfs.source_files = 'Classes/CloudFiles/*.{h,m}','Classes/S3/ASINSXMLParserCompat.h'
    cfs.dependency 'ASIHTTPRequest/Core'
    cfs.requires_arc = false
  end

  s.subspec 'S3' do |s3s|
    s3s.source_files = 'Classes/S3/*.{h,m}'
    s3s.dependency 'ASIHTTPRequest/Core'
    s3s.requires_arc = false
  end

end
