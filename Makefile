start: install-ansible
	vagrant up

stop:
	vagrant destroy -f

restart: stop start

provision:
	vagrant provision

ssh:
	vagrant ssh mon0

golint:
	[ -n "`which golint`" ] || go get github.com/golang/lint/golint
	golint ./...

build: golint
	godep go install -v ./

install-ansible:
	[ -n "`which ansible`" ] || sudo -E pip install ansible

test: golint
	vagrant ssh mon0 -c 'sudo -i sh -c "cd /opt/golang/src/github.com/contiv/volplugin; godep go test -v ./..."'

run-volplugin:
	vagrant ssh mon0 -c 'sudo -i sh -c "cd /opt/golang/src/github.com/contiv/volplugin; make volplugin-start"'

volplugin-start:
	pkill volplugin || exit 0
	sleep 1
	godep go install -v ./volplugin/
	DEBUG=1 volplugin volplugin rbd 1000000000