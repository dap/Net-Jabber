use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
	      'NAME'      => 'Net::Jabber',
	      'PM'        => {
			      'Jabber.pm' => '$(INST_LIBDIR)/Jabber.pm',
			      'Jabber/Debug.pm' => '$(INST_LIBDIR)/Jabber/Debug.pm',
			      'Jabber/Client.pm' => '$(INST_LIBDIR)/Jabber/Client.pm',
			      'Jabber/Transport.pm' => '$(INST_LIBDIR)/Jabber/Transport.pm',
			      'Jabber/Protocol.pm' => '$(INST_LIBDIR)/Jabber/Protocol.pm',
			      'Jabber/JID.pm' => '$(INST_LIBDIR)/Jabber/JID.pm',
			      'Jabber/Key.pm' => '$(INST_LIBDIR)/Jabber/Key.pm',
			      'Jabber/Message.pm' => '$(INST_LIBDIR)/Jabber/Message.pm',
			      'Jabber/Presence.pm' => '$(INST_LIBDIR)/Jabber/Presence.pm',
			      'Jabber/IQ.pm' => '$(INST_LIBDIR)/Jabber/IQ.pm',
			      'Jabber/Query.pm' => '$(INST_LIBDIR)/Jabber/Query.pm',
			      'Jabber/Query/Agent.pm' => '$(INST_LIBDIR)/Jabber/Query/Agent.pm',
			      'Jabber/Query/Agents.pm' => '$(INST_LIBDIR)/Jabber/Query/Agents.pm',
			      'Jabber/Query/Auth.pm' => '$(INST_LIBDIR)/Jabber/Query/Auth.pm',
			      'Jabber/Query/AutoUpdate.pm' => '$(INST_LIBDIR)/Jabber/Query/AutoUpdate.pm',
			      'Jabber/Query/AutoUpdate/Release.pm' => '$(INST_LIBDIR)/Jabber/Query/AutoUpdate/Release.pm',
			      'Jabber/Query/Filter.pm' => '$(INST_LIBDIR)/Jabber/Query/Filter.pm',
			      'Jabber/Query/Filter/Rule.pm' => '$(INST_LIBDIR)/Jabber/Query/Filter/Rule.pm',
			      'Jabber/Query/Fneg.pm' => '$(INST_LIBDIR)/Jabber/Query/Fneg.pm',
			      'Jabber/Query/Oob.pm' => '$(INST_LIBDIR)/Jabber/Query/Oob.pm',
			      'Jabber/Query/Register.pm' => '$(INST_LIBDIR)/Jabber/Query/Register.pm',
			      'Jabber/Query/Roster.pm' => '$(INST_LIBDIR)/Jabber/Query/Roster.pm',
			      'Jabber/Query/Roster/Item.pm' => '$(INST_LIBDIR)/Jabber/Query/Roster/Item.pm',
			      'Jabber/Query/Search.pm' => '$(INST_LIBDIR)/Jabber/Query/Search.pm',
			      'Jabber/Query/Search/Item.pm' => '$(INST_LIBDIR)/Jabber/Query/Search/Item.pm',
			      'Jabber/Query/Time.pm' => '$(INST_LIBDIR)/Jabber/Query/Time.pm',
			      'Jabber/Query/Version.pm' => '$(INST_LIBDIR)/Jabber/Query/Version.pm',
			      'Jabber/X.pm' => '$(INST_LIBDIR)/Jabber/X.pm',
			      'Jabber/X/AutoUpdate.pm' => '$(INST_LIBDIR)/Jabber/X/AutoUpdate.pm',
			      'Jabber/X/Delay.pm' => '$(INST_LIBDIR)/Jabber/X/Delay.pm',
			      'Jabber/X/GC.pm' => '$(INST_LIBDIR)/Jabber/X/GC.pm',
			      'Jabber/X/Ident.pm' => '$(INST_LIBDIR)/Jabber/X/Ident.pm',
			      'Jabber/X/Oob.pm' => '$(INST_LIBDIR)/Jabber/X/Oob.pm',
			      'Jabber/X/Roster.pm' => '$(INST_LIBDIR)/Jabber/X/Roster.pm',
			      'Jabber/X/Roster/Item.pm' => '$(INST_LIBDIR)/Jabber/X/Roster/Item.pm',
			     },
	      'PREREQ_PM' => {
			      'XML::Stream' => 1.05
			     },
	      'VERSION' => '1.0009',
	      'dist' => { 'COMPRESS' => 'gzip --best' }
	     );
