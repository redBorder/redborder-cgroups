%undefine __brp_mangle_shebangs

Name:       redborder-cgroups
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch:  noarch
Summary:    redborder-cgroups package for configuring cgroup in redborder environments

License:    GNU AGPLv3
URL:        https://github.com/redBorder/redborder-cgroups
Source0:    %{name}-%{version}.tar.gz

Requires: jq redborder-common

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/usr/lib/redborder/bin/
mkdir -p %{buildroot}/usr/lib/redborder/scripts/
mkdir -p %{buildroot}/etc/systemd/system/

install -D -m 0644 resources/systemd/* %{buildroot}/etc/systemd/system/
install -m 0755 resources/bin/* %{buildroot}/usr/lib/redborder/bin/
install -m 0755 resources/scripts/* %{buildroot}/usr/lib/redborder/scripts/

%pre

%post
/usr/lib/redborder/bin/rb_rubywrapper.sh -c
systemctl daemon-reload
systemctl enable redborder-cgroups

%files
%dir %attr(0755,root,root) /usr/lib/redborder
%dir %attr(0755,root,root) /usr/lib/redborder/scripts
%dir %attr(0755,root,root) /usr/lib/redborder/bin
%config(noreplace) %attr(0644,root,root) /etc/systemd/system/redborder-cgroups.service
/usr/lib/redborder/bin/*
/usr/lib/redborder/scripts/*
%doc

%changelog
* Tue Apr 23 2024 - Nils Verschaeve <nverschaeve@redborder.com>
- added redborder-common dependency
* Mon Mar 25 2024 - David Vanhoucke <dvanhoucke@redborder.com> - 0.1.1-1
- added jq dependency
* Fri Feb 23 2024 - Luis Blanco <ljblanco@redborder.com> - 0.1.0-1
- Ruby wrapper added, and unmangle shebangs
* Tue Sep 28 2023 - Miguel Álvarez <malvarez@redborder.com> - 0.0.1-1
- Initial spec version
