use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
	      'NAME'      => 'Net::Jabber',
	      'PM'        => {
			      'Jabber.pm' => '$(INST_LIBDIR)/Jabber.pm',
			      'Jabber/Client.pm' => '$(INST_LIBDIR)/Jabber/Client.pm',
			      'Jabber/Message.pm' => '$(INST_LIBDIR)/Jabber/Message.pm',
			      'Jabber/Presence.pm' => '$(INST_LIBDIR)/Jabber/Presence.pm',
			      'Jabber/IQ.pm' => '$(INST_LIBDIR)/Jabber/IQ.pm',
			      'Jabber/IQ/Auth.pm' => '$(INST_LIBDIR)/Jabber/IQ/Auth.pm',
			      'Jabber/IQ/Info.pm' => '$(INST_LIBDIR)/Jabber/IQ/Info.pm',
			      'Jabber/IQ/Register.pm' => '$(INST_LIBDIR)/Jabber/IQ/Register.pm',
			      'Jabber/IQ/Resource.pm' => '$(INST_LIBDIR)/Jabber/IQ/Resource.pm',
			      'Jabber/IQ/Roster.pm' => '$(INST_LIBDIR)/Jabber/IQ/Roster.pm',
			      'Jabber/IQ/Roster/Item.pm' => '$(INST_LIBDIR)/Jabber/IQ/Roster/Item.pm',
			      'Jabber/X.pm' => '$(INST_LIBDIR)/Jabber/X.pm',
			      'Jabber/X/Delay.pm' => '$(INST_LIBDIR)/Jabber/X/Delay.pm',
			      'Jabber/X/Ident.pm' => '$(INST_LIBDIR)/Jabber/X/Ident.pm',
			      'Jabber/X/Oob.pm' => '$(INST_LIBDIR)/Jabber/X/Oob.pm',
			     },
	      'PREREQ_PM' => {
			      'XML::Stream' => 0
			     },
	      'VERSION' => '0.8.1',
	      'dist' => { 'COMPRESS' => 'gzip --best' }
	     );
