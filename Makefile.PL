use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
	      'NAME'      => 'Net::Jabber',
	      'PM'        => {
			      'Jabber.pm' => '$(INST_LIBDIR)/Jabber.pm',
			      'Jabber/Client.pm' => '$(INST_LIBDIR)/Jabber/Client.pm',
			      'Jabber/Transport.pm' => '$(INST_LIBDIR)/Jabber/Transport.pm',
			      'Jabber/Protocol.pm' => '$(INST_LIBDIR)/Jabber/Protocol.pm',
			      'Jabber/JID.pm' => '$(INST_LIBDIR)/Jabber/JID.pm',
			      'Jabber/Message.pm' => '$(INST_LIBDIR)/Jabber/Message.pm',
			      'Jabber/Presence.pm' => '$(INST_LIBDIR)/Jabber/Presence.pm',
			      'Jabber/IQ.pm' => '$(INST_LIBDIR)/Jabber/IQ.pm',
			      'Jabber/Query.pm' => '$(INST_LIBDIR)/Jabber/Query.pm',
			      'Jabber/Query/Agent.pm' => '$(INST_LIBDIR)/Jabber/Query/Agent.pm',
			      'Jabber/Query/Agents.pm' => '$(INST_LIBDIR)/Jabber/Query/Agents.pm',
			      'Jabber/Query/Auth.pm' => '$(INST_LIBDIR)/Jabber/Query/Auth.pm',
			      'Jabber/Query/Fneg.pm' => '$(INST_LIBDIR)/Jabber/Query/Fneg.pm',
			      'Jabber/Query/Oob.pm' => '$(INST_LIBDIR)/Jabber/Query/Oob.pm',
			      'Jabber/Query/Register.pm' => '$(INST_LIBDIR)/Jabber/Query/Register.pm',
			      'Jabber/Query/Roster.pm' => '$(INST_LIBDIR)/Jabber/Query/Roster.pm',
			      'Jabber/Query/Roster/Item.pm' => '$(INST_LIBDIR)/Jabber/Query/Roster/Item.pm',
			      'Jabber/Query/Time.pm' => '$(INST_LIBDIR)/Jabber/Query/Time.pm',
			      'Jabber/Query/Version.pm' => '$(INST_LIBDIR)/Jabber/Query/Version.pm',
			      'Jabber/X.pm' => '$(INST_LIBDIR)/Jabber/X.pm',
			      'Jabber/X/Delay.pm' => '$(INST_LIBDIR)/Jabber/X/Delay.pm',
			      'Jabber/X/Ident.pm' => '$(INST_LIBDIR)/Jabber/X/Ident.pm',
			      'Jabber/X/Oob.pm' => '$(INST_LIBDIR)/Jabber/X/Oob.pm',
			      'Jabber/X/Roster.pm' => '$(INST_LIBDIR)/Jabber/X/Roster.pm',
			      'Jabber/X/Roster/Item.pm' => '$(INST_LIBDIR)/Jabber/X/Roster/Item.pm',
			     },
	      'PREREQ_PM' => {
			      'XML::Stream' => 0
			     },
	      'VERSION' => '0.8.1',
	      'dist' => { 'COMPRESS' => 'gzip --best' }
	     );
