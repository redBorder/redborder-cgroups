Name:     redborder-cgroups
Version:  %{__version}
Release:  %{__release}%{?dist}
BuildArch: noarch
Summary: redborder-cgroups package for configure cgroup in redborder environments


License:  GNU AGPLv3
URL:  https://github.com/redBorder/redborder-cgroups
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/usr/lib/redborder/bin/
mkdir -p %{buildroot}/usr/lib/redborder/scripts/

install -D -m 0644  resources/systemd/* %{buildroot}/etc/systemd/system/

cp reources/bin/* %{buildroot}/usr/lib/redborder/bin
cp resources/scripts/* %{buildroot}/usr/lib/redborder/scripts

%pre

%post
systemctl daemon-reload
systemctl enable redborder-cgroups
%files
%attr(0755,root,root)
/usr/lib/redborder/scripts
/usr/lib/redborder/bin

%doc

%changelog
* Mon Sep 25 2023 - Miguel Álvarez <malvarez@redborder.com> - 0.0.1-1
- Initial spec version
