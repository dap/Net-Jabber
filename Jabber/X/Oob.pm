package Net::Jabber::X::Delay;

=head1 NAME

Net::Jabber::X::Delay - Jabber X Delay Delegate

=head1 SYNOPSIS

  Net::Jabber::X::Delay is a companion to the Net::Jabber::X module.
  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber X Delay.

=head1 DESCRIPTION

  To initialize the Delay with a Jabber <x/> you must pass it the 
  XML::Parser Tree array from the module trying to access the <x/>.  
  In the callback function:

    use Net::Jabber;

    sub iq {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:delay");

      my $xTag;
      foreach $xTag (@xTags) {
	$xTag->....
	
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new Delay to send to the server:

    use Net::Jabber;

    $foo = new Net::Jabber::Foo();
    $x = $foo->NewX("jabber:x:delay");

  Now you can call the creation functions below.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $from      = $xTag->GetFrom();
    $stamp     = $xTag->GetStamp();
    $message   = $xTag->GetMessage();
    $xmlns     = $xTag->GetXMLNS();

=head2 Creation functions

    $IQ->SetX(FRom=>"jabber:foo.bar.com",
	      message=>"Stored offline");
    $IQ->SetFrom("bob@jabber.org");
    $IQ->SetStamp();
    $IQ->SetStamp("20000124T10:54:00");
    $IQ->SetMessage("Stored Offline");

=head1 METHODS

=head2 Retrieval functions

  GetFrom() - returns a string with the Jabber Identifier of the 
              person who added the delay.

  GetStamp() - returns a string that represents the time stamp of
               the delay.

  GetMessage() - returns a string with the message that describes
                 the nature of the delay.

  GetXMLNS() - returns a string with the namespace of the query that
               the <iq/> contains.

=head2 Creation functions

  SetX(from=>string,       - set multiple fields in the <x/> at one
       stamp=>string,        time.  This is a cumulative and over
       message=>string)      writing action.  If you set the "from"
                             attribute twice, the second setting is
                             what is used.  If you set the status, and
                             then set the priority then both will be in
                             the <x/> tag.  For valid settings read the
                             specific Set functions below.

  SetFrom(string) - sets the from attribute of the server adding the
                    delay.

  SetStamp(string) - sets the timestamp of the delay.  If the string is
                     left blank then the module adds the current date/time
                     in the proper format as the stamp.

  SetMessage(string) - sets description of the delay.
 
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
    $self->{X} = \@temp;
  } else {
    $self->{X} = [ "x" , [{}]];
  }

  return $self;
}


##############################################################################
#
# GetFrom - returns from of the jabber:x:delay
#
##############################################################################
sub GetFrom {
  my $self = shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{X},"","from");
}


##############################################################################
#
# GetStamp - returns the stamp of the jabber:x:delay
#
##############################################################################
sub GetStamp {
  my $self = shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{X},"","stamp");
}


##############################################################################
#
# GetMessage - returns the cdata of the jabber:x:delay
#
##############################################################################
sub GetMessage {
  my $self = shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{X},"","");
}


##############################################################################
#
# GetXMLS - returns the namespace of the jabber:x:delay
#
##############################################################################
sub GetXMLNS {
  my $self = shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{X},"","xmlns");  
}


##############################################################################
#
# SetX - takes a hash of all of the things you can set on a jabber:x:delay and
#        sets each one.
#
##############################################################################
sub SetX {
  my $self = shift;
  my $master = shift;
  my %x;
  while($#_ >= 0) { $x{ lc pop(@_) } = pop(@_); }

  $self->SetFrom($master,$x{from}) if exists($x{from});
  $self->SetStamp($master,$x{stamp}) if exists($x{stamp});
  $self->SetData($master,$x{data}) if exists($x{data});
}


##############################################################################
#
# SetFrom - sets the from attribute in the jabber:x:delay
#
##############################################################################
sub SetFrom {
  my $self = shift;
  my $self = shift;
  my ($from) = @_;
  &Net::Jabber::SetXMLData("single",$self->{X},"","",{from=>$from});
}


##############################################################################
#
# SetStamp - sets the stamp attribute in the jabber:x:delay
#
##############################################################################
sub SetStamp {
  my $self = shift;
  my $self = shift;
  my ($stamp) = @_;
  
  if ($stamp eq "") {
    my ($sec,$min,$hour,$mday,$mon,$year) = localtime(time);
    $stamp = ($year + 1900).($mon+1).$mday."T".$hour.":".$min.":".$sec;
  }
  &Net::Jabber::SetXMLData("single",$self->{X},"","",{stamp=>$stamp});
}


##############################################################################
#
# SetMessage - sets the cdata of the jabber:x:delay
#
##############################################################################
sub SetMessage {
  my $self = shift;
  my $self = shift;
  my ($message) = @_;
  &Net::Jabber::SetXMLData("single",$self->{X},"","$message",{});
}


1;
