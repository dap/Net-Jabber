package Net::Jabber::IQ::Register;

=head1 NAME

Net::Jabber::IQ::Register - Jabber IQ Registration Module

=head1 SYNOPSIS

  Net::Jabber::IQ::Register is a companion to the Net::Jabber::IQ module.
  It provides the user a simple interface to set and retrieve all parts 
  of a Jabber IQ Registration query.

=head1 DESCRIPTION

  To initialize the IQ with a Jabber <iq/> and then access the register
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      my $register = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new IQ register to send to the server:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $IQ = new Net::Jabber::IQ();
    $Register = $IQ->NewQuery("register");
    ...

    $Client->Send($IQ);

  Using $Register you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $username = $Register->GetUsername();
    $password = $Register->GetPassword();
    $resource = $Register->GetResource();

    @register = $Register->GetTree();
    $str      = $Register->GetXML();

=head2 Creation functions

    $Register->SetRegister(username=>'test',
                           password=>'user',
                           resource=>'Test Account');

    $Register->SetUsername('bob');
    $Register->SetPassword('bobrulez');
    $Register->SetResource('Bob the Great');

=head1 METHODS

=head2 Retrieval functions

  GetUsername() - returns a string with the username in the <query/>.

  GetPassword() - returns a string with the password in the <query/>.

  GetResource() - returns a string with the resource in the <query/>.

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetRegister(username=>string, - set multiple fields in the <iq/>
              password=>string,   at one time.  This is a cumulative
              resource=>string)   and over writing action.  If you
                                  set the "username" twice, the second
                                  setting is what is used.  If you set
                                  the password, and then set the
                                  resource then both will be in the
                                  <query/> tag.  For valid settings
                                  read  the specific Set functions below.

  SetUsername(string) - sets the username for the account you are
                        trying to connect with.  Leave blank for
                        an anonymous account.

  SetPassword(string) - sets the password for the account you are
                        trying to connect with.  Leave blank for
                        an anonymous account.

  SetResource(string) - sets the resource for the account you are
                        trying to connect with.  Leave blank for
                        an anonymous account.

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
    $self->{REGISTER} = \@temp;
  } else {
    $self->{REGISTER} = [ "query" , [{xmlns=>"jabber:iq:register"}]];
  }

  return $self;
}


##############################################################################
#
# GetUsername - returns the username in the <query/>.
#
##############################################################################
sub GetUsername {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{REGISTER},"username");
}


##############################################################################
#
# GetPassword - returns the password in the <query/>.
#
##############################################################################
sub GetPassword {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{REGISTER},"password");
}


##############################################################################
#
# GetResource - returns the resource in the <query/>.
#
##############################################################################
sub GetResource {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{REGISTER},"resource");
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  return &Net::Jabber::BuildXML(@{$self->{REGISTER}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;  
  return @{$self->{REGISTER}};
}


##############################################################################
#
# SetRegister - takes a hash of all of the things you can set on an register <query/>
#           and sets each one.
#
##############################################################################
sub SetRegister {
  my $self = shift;
  my %register;
  while($#_ >= 0) { $register{ lc pop(@_) } = pop(@_); }
  
  $self->SetUsername($register{username}) if exists($register{username});
  $self->SetPassword($register{password}) if exists($register{password});
  $self->SetResource($register{username}) if exists($register{resource});
}


##############################################################################
#
# SetUsername - sets the username of the account you want to connect with.
#
##############################################################################
sub SetUsername {
  my $self = shift;
  my ($username) = @_;
  &Net::Jabber::SetXMLData("single",$self->{REGISTER},"username",$username,{});
}


##############################################################################
#
# SetPassword - sets the password of the account you want to connect with.
#
##############################################################################
sub SetPassword {
  my $self = shift;
  my ($password) = @_;
  &Net::Jabber::SetXMLData("single",$self->{REGISTER},"password",$password,{});
}


##############################################################################
#
# SetResource - sets the resource of the account you want to connect with.
#
##############################################################################
sub SetResource {
  my $self = shift;
  my ($resource) = @_;
  &Net::Jabber::SetXMLData("single",$self->{REGISTER},"resource",$resource,{});
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for debugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug REGISTER: $self\n";
  &Net::Jabber::printData("debug: \$self->{REGISTER}->",$self->{REGISTER});
}

1;
