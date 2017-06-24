Pod::Spec.new do |kabukit|
  kabukit.name             = 'KabuKit'
  kabukit.version          = '0.3.0'
  kabukit.summary          = 'A short description of Proto.'
  kabukit.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

  kabukit.homepage         = 'https://github.com/crexista/KabuKit.git'
  kabukit.license          = { :type => 'MIT', :file => 'LICENSE' }
  kabukit.author           = { 'crexista' => 'crexista[at]gmail.com' }
  kabukit.source           = { :git => 'https://github.com/crexista/KabuKit.git', :tag => kabukit.version.to_s }

  kabukit.requires_arc          = true
  kabukit.ios.deployment_target = '8.0'

  kabukit.subspec 'Scene' do |core|
    core.source_files = 'KabuKit/Classes/core/Swift/*.swift'
    core.ios.source_files = 'KabuKit/Classes/ios/Swift/*.swift'
  end
  
  kabukit.default_subspecs = 'Scene'
end

