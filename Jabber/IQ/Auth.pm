package Net::Jabber::IQ::Auth;

=head1 NAME

Net::Jabber::IQ::Auth - Jabber IQ Authentication Module

=head1 SYNOPSIS

  Net::Jabber::IQ::Auth is a companion to the Net::Jabber::IQ module.
  It provides the user a simple interface to set and retrieve all parts
  of a Jabber IQ Authentication query.

=head1 DESCRIPTION

  To initialize the IQ with a Jabber <iq/> and then access the auth
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      my $auth = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new IQ auth to send to the server:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $IQ = new Net::Jabber::IQ();
    $Auth = $IQ->NewQuery("auth");
    ...

    $Client->Send($IQ);

  Using $Auth you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $username = $Auth->GetUsername();
    $password = $Auth->GetPassword();
    $resource = $Auth->GetResource();

    @auth     = $Auth->GetTree();
    $str      = $Auth->GetXML();

=head2 Creation functions

    $Auth->SetAuth(resource=>'Anonymous');
    $Auth->SetAuth(username=>'test',
                   password=>'user',
                   resource=>'Test Account');

    $Auth->SetUsername('bob');
    $Auth->SetPassword('bobrulez');
    $Auth->SetResource('Bob the Great');

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

  SetAuth(username=>string, - set multiple fields in the <iq/> at one
          password=>string,   time.  This is a cumulative and over
          resource=>string)   writing action.  If you set the "username" 
                              twice, the second setting is what is
                              used.  If you set the password, and then
                              set the resource then both will be in the
                              <query/> tag.  For valid settings read 
                              the specific Set functions below.

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
    $self->{AUTH} = \@temp;
  } else {
    $self->{AUTH} = [ "query" , [{xmlns=>"jabber:iq:auth"}]];
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
  return &Net::Jabber::GetXMLData("value",$self->{AUTH},"username");
}


##############################################################################
#
# GetPassword - returns the password in the <query/>.
#
##############################################################################
sub GetPassword {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{AUTH},"password");
}


##############################################################################
#
# GetResource - returns the resource in the <query/>.
#
##############################################################################
sub GetResource {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{AUTH},"resource");
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  return &Net::Jabber::BuildXML(@{$self->{AUTH}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;  
  return @{$self->{AUTH}};
}


##############################################################################
#
# SetAuth - takes a hash of all of the things you can set on an auth <query/>
#           and sets each one.
#
##############################################################################
sub SetAuth {
  my $self = shift;
  my %auth;
  while($#_ >= 0) { $auth{ lc pop(@_) } = pop(@_); }
  
  $self->SetUsername($auth{username}) if exists($auth{username});
  $self->SetPassword($auth{password}) if exists($auth{password});
  $self->SetResource($auth{resource}) if exists($auth{resource});
  $self->SetResource("Anonymous") if !exists($auth{resource});
}


##############################################################################
#
# SetUsername - sets the username of the account you want to connect with.
#
##############################################################################
sub SetUsername {
  my $self = shift;
  my ($username) = @_;
  &Net::Jabber::SetXMLData("single",$self->{AUTH},"username",$username,{});
}


##############################################################################
#
# SetPassword - sets the password of the account you want to connect with.
#
##############################################################################
sub SetPassword {
  my $self = shift;
  my ($password) = @_;
  &Net::Jabber::SetXMLData("single",$self->{AUTH},"password",$password,{});
}


##############################################################################
#
# SetResource - sets the resource of the account you want to connect with.
#
##############################################################################
sub SetResource {
  my $self = shift;
  my ($resource) = @_;
  &Net::Jabber::SetXMLData("single",$self->{AUTH},"resource",$resource,{});
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for debugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug AUTH: $self\n";
  &Net::Jabber::printData("debug: \$self->{AUTH}->",$self->{AUTH});
}

1;
