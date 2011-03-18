Summary: my configuration/enhancement for interactive Zsh use
Name: mmc-zsh
Version: 1
Release: 1
License: GPL
Group: Shell
#URL: 
Source0: %{name}
#-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot

%description
 functions & key bindings.
%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc


%changelog
