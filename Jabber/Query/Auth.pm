##############################################################################
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Library General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Library General Public License for more details.
#
#  You should have received a copy of the GNU Library General Public
#  License along with this library; if not, write to the
#  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
#  Boston, MA  02111-1307, USA.
#
#  Jabber
#  Copyright (C) 1998-1999 The Jabber Team http://jabber.org/
#
##############################################################################

package Net::Jabber::Query::Auth;

=head1 NAME

Net::Jabber::Query::Auth - Jabber IQ Authentication Module

=head1 SYNOPSIS

  Net::Jabber::Query::Auth is a companion to the Net::Jabber::Query module.
  It provides the user a simple interface to set and retrieve all parts
  of a Jabber Authentication query.

=head1 DESCRIPTION

  To initialize the Query with a Jabber <iq/> and then access the auth
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iqCB {
      my $iq = new Net::Jabber::IQ(@_);
      my $auth = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new Query auth to send to the server:

    use Net::Jabber;

    $client = new Net::Jabber::Client();
    ...

    $iq = new Net::Jabber::IQ();
    $auth = $iq->NewQuery("jabber:iq:auth");
    ...

    $client->Send($iq);

  Using $auth you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $username = $auth->GetUsername();
    $password = $auth->GetPassword();
    $digest   = $auth->GetDigest();
    $resource = $auth->GetResource();

=head2 Creation functions

    $auth->SetAuth(resource=>'Anonymous');
    $auth->SetAuth(username=>'test',
                   password=>'user',
                   resource=>'Test Account');

    $auth->SetUsername('bob');
    $auth->SetPassword('bobrulez');
    $auth->SetDigest('');
    $auth->SetResource('Bob the Great');

=head2 Test functions

    $test = $auth->DefinedUsername();
    $test = $auth->DefinedPassword();
    $test = $auth->DefinedDigest();
    $test = $auth->DefinedResource();

=head1 METHODS

=head2 Retrieval functions

  GetUsername() - returns a string with the username in the <query/>.

  GetPassword() - returns a string with the password in the <query/>.

  GetDigest() - returns a string with the SHA-1 digest in the <query/>.

  GetResource() - returns a string with the resource in the <query/>.

=head2 Creation functions

  SetAuth(username=>string, - set multiple fields in the <iq/> at one
          password=>string,   time.  This is a cumulative and over
          digest=>string,     writing action.  If you set the "username" 
          resource=>string)   twice, the second setting is what is
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

  SetDigest(string) - sets the SHA-1 digest for the account you are
                      trying to connect with.  Leave blank for
                      an anonymous account.

  SetResource(string) - sets the resource for the account you are
                        trying to connect with.  Leave blank for
                        an anonymous account.

=head2 Test functions

  DefinedUsername() - returns 1 if <username/> exists in the <iq/>,
                      0 otherwise.

  DefinedPassword() - returns 1 if <password/> exists in the <iq/>,
                      0 otherwise.

  DefinedDigest() - returns 1 if <digest/> exists in the <iq/>,
                    0 otherwise.

  DefinedResource() - returns 1 if <resource/> exists in the <iq/>,
                      0 otherwise.


=head1 AUTHOR

By Ryan Eatmon in July of 2000 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.0019";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;
  
  bless($self, $proto);
  
  return $self;
}


##############################################################################
#
# AUTOLOAD - This function calls the delegate with the appropriate function
#            name and argument list.
#
##############################################################################
sub AUTOLOAD {
  my $parent = shift;
  my $self = shift;
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = "QUERY";

  return &Net::Jabber::Get($parent,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($parent,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($parent,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  &Net::Jabber::MissingFunction($parent,$AUTOLOAD);
}


$FUNCTIONS{get}->{Username} = ["value","username",""];
$FUNCTIONS{get}->{Password} = ["value","password",""];
$FUNCTIONS{get}->{Resource} = ["value","resource",""];
$FUNCTIONS{get}->{Digest}   = ["value","digest",""];

$FUNCTIONS{set}->{Username} = ["single","username","*","",""];
$FUNCTIONS{set}->{Password} = ["single","password","*","",""];
$FUNCTIONS{set}->{Resource} = ["single","resource","*","",""];
$FUNCTIONS{set}->{Digest}   = ["single","digest","*","",""];

$FUNCTIONS{defined}->{Username} = ["existence","username",""];
$FUNCTIONS{defined}->{Password} = ["existence","password",""];
$FUNCTIONS{defined}->{Resource} = ["existence","resource",""];
$FUNCTIONS{defined}->{Digest}   = ["existence","digest",""];


##############################################################################
#
# SetAuth - takes a hash of all of the things you can set on an auth <query/>
#           and sets each one.
#
##############################################################################
sub SetAuth {
  shift;
  my $self = shift;
  my %auth;
  while($#_ >= 0) { $auth{ lc pop(@_) } = pop(@_); }
  
  $self->SetUsername($auth{username}) if exists($auth{username});
  $self->SetPassword($auth{password}) if exists($auth{password});
  $self->SetDigest($auth{digest}) if exists($auth{digest});
  $self->SetResource($auth{resource}) if exists($auth{resource});
  $self->SetResource("Anonymous") if !exists($auth{resource});
}


1;
