package Net::Jabber::IQ::Info;

=head1 NAME

Net::Jabber::IQ::Info - Jabber IQ Information Module



  .....Under Development.....



=head1 SYNOPSIS

  Net::Jabber::IQ::Info is a companion to the Net::Jabber::IQ module.
  It provides the user a simple interface to set and retrieve all parts
  of a Jabber IQ Information query.

=head1 DESCRIPTION

  To initialize the IQ with a Jabber <iq/> and then access the info
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      my $info = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new IQ info to send to the server:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $IQ = new Net::Jabber::IQ();
    $Info = $IQ->NewQuery("info");
    ...

    $Client->Send($IQ);

  Using $Info you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    @info     = $Info->GetTree();
    $str      = $Info->GetXML();

=head2 Creation functions

=head1 METHODS

=head2 Retrieval functions

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

=head1 AUTHOR

By Ryan Eatmon in December of 1999 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION);

$VERSION = "0.8.1";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  if (@_ != ("")) {
    my @temp = @_;
    $self->{INFO} = \@temp;
  } else {
    $self->{INFO} = [ "query" , [{xmlns=>"jabber:iq:info"}]];
  }

  return $self;
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  return &Net::Jabber::BuildXML(@{$self->{INFO}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;  
  return @{$self->{INFO}};
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for dbeugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug INFO: $self\n";
  &Net::Jabber::printData("debug: \$self->{INFO}->",$self->{INFO});
}

1;
