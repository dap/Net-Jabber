use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'      => 'Net::Jabber',
    'PM'        => {
        'Jabber.pm' => '$(INST_LIBDIR)/Jabber.pm',
        'Jabber/Debug.pm' => '$(INST_LIBDIR)/Jabber/Debug.pm',
        'Jabber/Client.pm' => '$(INST_LIBDIR)/Jabber/Client.pm',
        'Jabber/Component.pm' => '$(INST_LIBDIR)/Jabber/Component.pm',
        'Jabber/Server.pm' => '$(INST_LIBDIR)/Jabber/Server.pm',
        'Jabber/Protocol.pm' => '$(INST_LIBDIR)/Jabber/Protocol.pm',
        'Jabber/JID.pm' => '$(INST_LIBDIR)/Jabber/JID.pm',
        'Jabber/Key.pm' => '$(INST_LIBDIR)/Jabber/Key.pm',
        'Jabber/Message.pm' => '$(INST_LIBDIR)/Jabber/Message.pm',
        'Jabber/Namespaces.pm' => '$(INST_LIBDIR)/Jabber/Namespaces.pm',
        'Jabber/Presence.pm' => '$(INST_LIBDIR)/Jabber/Presence.pm',
        'Jabber/IQ.pm' => '$(INST_LIBDIR)/Jabber/IQ.pm',
        'Jabber/XDB.pm' => '$(INST_LIBDIR)/Jabber/XDB.pm',
        'Jabber/Log.pm' => '$(INST_LIBDIR)/Jabber/Log.pm',
        'Jabber/Data.pm' => '$(INST_LIBDIR)/Jabber/Data.pm',
        'Jabber/Dialback.pm' => '$(INST_LIBDIR)/Jabber/Dialback.pm',
        'Jabber/Dialback/Result.pm' => '$(INST_LIBDIR)/Jabber/Dialback/Result.pm',
        'Jabber/Dialback/Verify.pm' => '$(INST_LIBDIR)/Jabber/Dialback/Verify.pm',
        'Jabber/Query.pm' => '$(INST_LIBDIR)/Jabber/Query.pm',
        'Jabber/X.pm' => '$(INST_LIBDIR)/Jabber/X.pm',
    },
    'PREREQ_PM' => {
        'XML::Stream' => 1.16,
        'Digest::SHA1' => 1.02
    },
    'VERSION' => '1.28',
    'dist' => {
        'COMPRESS' => 'gzip --best'
    }
);
