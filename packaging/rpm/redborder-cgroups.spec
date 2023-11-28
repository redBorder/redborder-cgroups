Name:       redborder-cgroups
Version:    0.0.1
Release:    1%{?dist}
BuildArch:  noarch
Summary:    redborder-cgroups package for configuring cgroup in redborder environments

License:    GNU AGPLv3
URL:        https://github.com/redBorder/redborder-cgroups
Source0:    %{name}-%{version}.tar.gz

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

cp resources/bin/* %{buildroot}/usr/lib/redborder/bin
cp resources/scripts/* %{buildroot}/usr/lib/redborder/scripts

%pre

%post
systemctl daemon-reload
systemctl enable redborder-cgroups

%files
%dir %attr(0755,root,root) /usr/lib/redborder
%dir %attr(0755,root,root) /usr/lib/redborder/scripts
%dir %attr(0755,root,root) /usr/lib/redborder/bin
%config(noreplace) %attr(0644,root,root) /etc/systemd/system/redborder-cgroups.service
%doc

%changelog
* Mon Sep 25 2023 - Miguel Álvarez <malvarez@redborder.com> - 0.0.1-1
- Initial spec version

