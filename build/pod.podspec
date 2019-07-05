Pod::Spec.new do |spec|
  spec.name         = 'Gbas'
  spec.version      = '{{.Version}}'
  spec.license      = { :type => 'GNU Lesser General Public License, Version 3.0' }
  spec.homepage     = 'https://github.com/abassian/go-abassian'
  spec.authors      = { {{range .Contributors}}
		'{{.Name}}' => '{{.Email}}',{{end}}
	}
  spec.summary      = 'iOS Abassian Client'
  spec.source       = { :git => 'https://github.com/abassian/go-abassian.git', :commit => '{{.Commit}}' }

	spec.platform = :ios
  spec.ios.deployment_target  = '9.0'
	spec.ios.vendored_frameworks = 'Frameworks/Gbas.framework'

	spec.prepare_command = <<-CMD
    curl https://gbasstore.blob.core.windows.net/builds/{{.Archive}}.tar.gz | tar -xvz
    mkdir Frameworks
    mv {{.Archive}}/Gbas.framework Frameworks
    rm -rf {{.Archive}}
  CMD
end
