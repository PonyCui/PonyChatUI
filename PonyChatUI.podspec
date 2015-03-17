
Pod::Spec.new do |s|

  s.name         = "PonyChatUI"
  s.version      = "0.0.1"
  s.summary      = "A short description of PonyChatUI."

  s.description  = <<-DESC
                   A longer description of PonyChatUI in Markdown format.
                   DESC

  s.homepage     = "https://github.com/PonyGroup/PonyChatUI"

  s.license      = "MIT"

  s.author             = { "ponycui" => "ponycui@me.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/PonyGroup/PonyChatUI.git" }

  s.source_files  = "PonyChatUI", "PonyChatUI/Classes", "PonyChatUI/Classes/**", "PonyChatUI/Classes/**/**", "PonyChatUI/Classes/**/**/**", "PonyChatUI/Classes/**/**/**/**"

  s.resources = "PonyChatUI/Resources/*.{storyboard,xcassets}"

  s.frameworks = "AVFoundation", "CoreAudio"

  s.requires_arc = true

  s.dependency "Objection"
  s.dependency "ReactiveCocoa"
  s.dependency "AFNetworking"
  s.dependency "TMCache"

end
