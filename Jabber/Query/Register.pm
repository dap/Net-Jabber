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

package Net::Jabber::Query::Register;

=head1 NAME

Net::Jabber::Query::Register - Jabber IQ Registration Module

=head1 SYNOPSIS

  Net::Jabber::Query::Register is a companion to the Net::Jabber::Query module.
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

    $client = new Net::Jabber::Client();
    ...

    $iq = new Net::Jabber::IQ();
    $register = $iq->NewQuery("jabber:iq:register");
    ...

    $client->Send($iq);

  Using $register you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $instructions = $register->GetInstructions();

    $username   = $register->GetUsername();
    $password   = $register->GetPassword();
    $name       = $register->GetName();
    $first      = $register->GetFirst();
    $last       = $register->GetLast();
    $nick       = $register->GetNick();
    $email      = $register->GetEmail();
    $address    = $register->GetAddress();
    $city       = $register->GetCity();
    $state      = $register->GetState();
    $zip        = $register->GetZip();
    $phone      = $register->GetPhone();
    $url        = $register->GetURL();
    $date       = $register->GetDate();
    $misc       = $register->GetMisc();
    $text       = $register->GetText();
    $key        = $register->GetKey();
    $remove     = $register->GetRemove();
    $registered = $register->GetRegistered();

    %fields = $register->GetFields();

=head2 Client Creation functions

    $register->SetRegister(username=>'test',
                           password=>'user',
                           name=>'Test Account');

    $register->SetUsername('bob');
    $register->SetPassword('bobrulez');
    $register->SetName('Bob the Great');
    $register->SetFirst('Bob');
    $register->SetLast('Smith');
    $register->SetNick('bobocity');
    $register->SetEmail('bob\@bob.net');
    $register->SetAddress('121 Bob St.');
    $register->SetCity('Bobville');
    $register->SetState('TX');
    $register->SetZip('70000');
    $register->SetPhone('(555)555-5555');
    $register->SetURL('http://www.bob.net');
    $register->SetDate('04/17/2000');
    $register->SetMisc('...');
    $register->SetText('...');
    $register->SetKey('...');
    $register->SetRemove();

=head2 Server Creation functions

    $register->SetRegister(instructions=>'Fill out the following fields...',
			   username=>'',
                           password=>'',
                           name=>'',
	       	           email=>'');

    $register->SetInstructions('Fill out all of the fields...');

    $register->SetUsername();
    $register->SetPassword();
    $register->SetName();
    $register->SetFirst();
    $register->SetLast();
    $register->SetNick();
    $register->SetEmail();
    $register->SetAddress();
    $register->SetCity();
    $register->SetState();
    $register->SetZip();
    $register->SetPhone();
    $register->SetURL();
    $register->SetDate();
    $register->SetMisc();
    $register->SetText();
    $register->SetKey();
    $register->SetRemove();
    $register->SetRegistered();

=head2 Test functions

    $test = $register->DefinedUsername();
    $test = $register->DefinedPassword();
    $test = $register->DefinedName();
    $test = $register->DefinedFirst();
    $test = $register->DefinedLast();
    $test = $register->DefinedNick();
    $test = $register->DefinedEmail();
    $test = $register->DefinedAddress();
    $test = $register->DefinedCity();
    $test = $register->DefinedState();
    $test = $register->DefinedZip();
    $test = $register->DefinedPhone();
    $test = $register->DefinedURL();
    $test = $register->DefinedDate();
    $test = $register->DefinedMisc();
    $test = $register->DefinedText();
    $test = $register->DefinedKey();
    $test = $register->DefinedRemove();
    $test = $register->DefinedRegistered();

=head1 METHODS

=head2 Retrieval functions

  GetInstructions() - returns a string with the instructions in the <query/>.

  GetUsername() - returns a string with the username in the <query/>.

  GetPassword() - returns a string with the password in the <query/>.

  GetName() - returns a string with the name in the <query/>.

  GetFirst() - returns a string with the fisrt in the <query/>.

  GetLast() - returns a string with the last in the <query/>.

  GetNick() - returns a string with the nick in the <query/>.

  GetEmail() -  returns a string with the email in the <query/>.

  GetAddress() -  returns a string with the address in the <query/>.

  GetCity() -  returns a string with the city in the <query/>.

  GetState() -  returns a string with the state in the <query/>.

  GetZip() -  returns a string with the zip in the <query/>.

  GetPhone() -  returns a string with the phone in the <query/>.

  GetURL() -  returns a string with the URL in the <query/>.

  GetDate() -  returns a string with the date in the <query/>.

  GetMisc() -  returns a string with the misc in the <query/>.

  GetText() -  returns a string with the text in the <query/>.

  GetKey() -  returns a string with the key in the <query/>.

  GetRemove() -  returns a string with the remove in the <query/>.

  GetRegistered() -  returns a string with the registered in the <query/>.

  GetFields() -  returns a hash with the keys being the fields
                 contained in the <query/> and the values the
                 contents of the tags.

=head2 Creation functions

  SetRegister(instructions=>string, - set multiple fields in the <iq/>
	      username=>string,       at one time.  This is a cumulative
              password=>string,       and over writing action.  If you
              name=>string,           set the "username" twice, the second
              first=>string,          setting is what is used.  If you set
              last=>string,           the password, and then set the 
              nick=>string,           name then both will be in the
              email=>string,          <query/> tag.  For valid settings
              address=>string,        read  the specific Set functions below.
              city=>string,
              state=>string,
              zip=>string,
              phone=>string,
              url=>string,
              date=>string,
              misc=>string,
              text=>string,
              key=>string,
              remove=>string,
	      registered=>string)
 
  SetUsername(string) - sets the username for the account you are
                        trying to create.  Set string to "" to send
                        <username/> for instructions.

  SetPassword(string) - sets the password for the account you are
                        trying to create.  Set string to "" to send
                        <password/> for instructions.

  SetName(string) - sets the name for the account you are
                    trying to create.  Set string to "" to send
                    <name/> for instructions.

  SetFirst(string) - sets the first for the account you are
                    trying to create.  Set string to "" to send
                    <first/> for instructions.

  SetLast(string) - sets the last for the account you are
                    trying to create.  Set string to "" to send
                    <last/> for instructions.

  SetNick(string) - sets the nick for the account you are
                    trying to create.  Set string to "" to send
                    <nick/> for instructions.

  SetEmail(string) - sets the email for the account you are
                     trying to create.  Set string to "" to send
                     <email/> for instructions.

  SetAddress(string) - sets the addess for the account you are
                       trying to create.  Set string to "" to send
                       <address/> for instructions.

  SetCity(string) - sets the city for the account you are
                    trying to create.  Set string to "" to send
                    <city/> for instructions.

  SetState(string) - sets the state for the account you are
                     trying to create.  Set string to "" to send
                     <state/> for instructions.

  SetZip(string) - sets the zip code for the account you are
                   trying to create.  Set string to "" to send
                   <zip/> for instructions.

  SetPhone(string) - sets the phone for the account you are
                     trying to create.  Set string to "" to send
                     <phone/> for instructions.

  SetURL(string) - sets the url for the account you are
                   trying to create.  Set string to "" to send
                   <url/> for instructions.

  SetDate(string) - sets the date for the account you are
                    trying to create.  Set string to "" to send
                    <date/> for instructions.

  SetMisc(string) - sets the misc for the account you are
                    trying to create.  Set string to "" to send
                    <misc/> for instructions.

  SetText(string) - sets the text for the account you are
                    trying to create.  Set string to "" to send
                    <text/> for instructions.

  SetKey(string) - sets the key for the server/transport you are trying 
                   to regsiter to.

  SetRemove() - sets the remove for the account you are trying to 
                delete so that the account will be removed from the 
                server/transport.

  SetRegistered() - sets the registered for the account you are trying to 
                    create so that the account will know that it is 
                    already registered.

=head2 Test functions

  DefinedUsername() - returns 1 if there is a <username/> in the query,
                      0 if not.

  DefinedPassword() - returns 1 if there is a <password/> in the query,
                      0 if not.

  DefinedName() - returns 1 if there is a <name/> in the query,
                  0 if not.

  DefinedFirst() - returns 1 if there is a <first/> in the query,
                  0 if not.

  DefinedLast() - returns 1 if there is a <last/> in the query,
                  0 if not.

  DefinedNick() - returns 1 if there is a <nick/> in the query,
                  0 if not.

  DefinedEmail() - returns 1 if there is a <email/> in the query,
                   0 if not.

  DefinedAddress() - returns 1 if there is a <address/> in the query,
                     0 if not.

  DefinedCity() - returns 1 if there is a <city/> in the query,
                  0 if not.

  DefinedState() - returns 1 if there is a <state/> in the query,
                   0 if not.

  DefinedZip() - returns 1 if there is a <zip/> in the query,
                 0 if not.

  DefinedPhone() - returns 1 if there is a <phone/> in the query,
                   0 if not.

  DefinedURL() - returns 1 if there is a <url/> in the query,
                 0 if not.

  DefinedDate() - returns 1 if there is a <date/> in the query,
                  0 if not.

  DefinedMisc() - returns 1 if there is a <misc/> in the query,
                  0 if not.

  DefinedText() - returns 1 if there is a <text/> in the query,
                  0 if not.

  DefinedKey() - returns 1 if there is a <key/> in the query,
                 0 if not.

  DefinedRemove() - returns 1 if there is a <remove/> in the query,
                    0 if not.

  DefinedRegistered() - returns 1 if there is a <registered/> in the query,
                        0 if not.

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

$VERSION = "1.0021";

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

$FUNCTIONS{get}->{Instructions} = ["value","instructions",""];
$FUNCTIONS{get}->{Username}     = ["value","username",""];
$FUNCTIONS{get}->{Password}     = ["value","password",""];
$FUNCTIONS{get}->{Name}         = ["value","name",""];
$FUNCTIONS{get}->{First}        = ["value","first",""];
$FUNCTIONS{get}->{Last}         = ["value","last",""];
$FUNCTIONS{get}->{Nick}         = ["value","nick",""];
$FUNCTIONS{get}->{Email}        = ["value","email",""];
$FUNCTIONS{get}->{Address}      = ["value","address",""];
$FUNCTIONS{get}->{City}         = ["value","city",""];
$FUNCTIONS{get}->{State}        = ["value","state",""];
$FUNCTIONS{get}->{Zip}          = ["value","zip",""];
$FUNCTIONS{get}->{Phone}        = ["value","phone",""];
$FUNCTIONS{get}->{URL}          = ["value","url",""];
$FUNCTIONS{get}->{Date}         = ["value","date",""];
$FUNCTIONS{get}->{Misc}         = ["value","misc",""];
$FUNCTIONS{get}->{Text}         = ["value","text",""];
$FUNCTIONS{get}->{Key}          = ["value","key",""];
$FUNCTIONS{get}->{Remove}       = ["value","remove",""];
$FUNCTIONS{get}->{Registered}   = ["value","registered",""];

$FUNCTIONS{set}->{Instructions} = ["single","instructions","*","",""];
$FUNCTIONS{set}->{Username}     = ["single","username","*","",""];
$FUNCTIONS{set}->{Password}     = ["single","password","*","",""];
$FUNCTIONS{set}->{Name}         = ["single","name","*","",""];
$FUNCTIONS{set}->{First}        = ["single","first","*","",""];
$FUNCTIONS{set}->{Last}         = ["single","last","*","",""];
$FUNCTIONS{set}->{Nick}         = ["single","nick","*","",""];
$FUNCTIONS{set}->{Email}        = ["single","email","*","",""];
$FUNCTIONS{set}->{Address}      = ["single","address","*","",""];
$FUNCTIONS{set}->{City}         = ["single","city","*","",""];
$FUNCTIONS{set}->{State}        = ["single","state","*","",""];
$FUNCTIONS{set}->{Zip}          = ["single","zip","*","",""];
$FUNCTIONS{set}->{Phone}        = ["single","phone","*","",""];
$FUNCTIONS{set}->{URL}          = ["single","url","*","",""];
$FUNCTIONS{set}->{Date}         = ["single","date","*","",""];
$FUNCTIONS{set}->{Misc}         = ["single","misc","*","",""];
$FUNCTIONS{set}->{Text}         = ["single","text","*","",""];
$FUNCTIONS{set}->{Key}          = ["single","key","*","",""];
$FUNCTIONS{set}->{Remove}       = ["single","remove","*","",""];
$FUNCTIONS{set}->{Registered}   = ["single","registered","*","",""];

$FUNCTIONS{defined}->{Instructions} = ["existence","instructions",""];
$FUNCTIONS{defined}->{Username}     = ["existence","username",""];
$FUNCTIONS{defined}->{Password}     = ["existence","password",""];
$FUNCTIONS{defined}->{Name}         = ["existence","name",""];
$FUNCTIONS{defined}->{First}        = ["existence","first",""];
$FUNCTIONS{defined}->{Last}         = ["existence","last",""];
$FUNCTIONS{defined}->{Nick}         = ["existence","nick",""];
$FUNCTIONS{defined}->{Email}        = ["existence","email",""];
$FUNCTIONS{defined}->{Address}      = ["existence","address",""];
$FUNCTIONS{defined}->{City}         = ["existence","city",""];
$FUNCTIONS{defined}->{State}        = ["existence","state",""];
$FUNCTIONS{defined}->{Zip}          = ["existence","zip",""];
$FUNCTIONS{defined}->{Phone}        = ["existence","phone",""];
$FUNCTIONS{defined}->{URL}          = ["existence","url",""];
$FUNCTIONS{defined}->{Date}         = ["existence","date",""];
$FUNCTIONS{defined}->{Misc}         = ["existence","misc",""];
$FUNCTIONS{defined}->{Text}         = ["existence","text",""];
$FUNCTIONS{defined}->{Key}          = ["existence","key",""];
$FUNCTIONS{defined}->{Remove}       = ["existence","remove",""];
$FUNCTIONS{defined}->{Registered}   = ["existence","registered",""];


##############################################################################
#
# GetFields - returns a hash that contains the fields and values that in the
#             <query/>.
#
##############################################################################
sub GetFields {
  shift;
  my $self = shift;
  my %fields;

  $fields{instructions} = $self->GetInstructions() if ($self->DefinedInstructions() == 1);
  $fields{username} = $self->GetUsername() if ($self->DefinedUsername() == 1);
  $fields{password} = $self->GetPassword() if ($self->DefinedPassword() == 1);
  $fields{name} = $self->GetName() if ($self->DefinedName() == 1);
  $fields{first} = $self->GetFirst() if ($self->DefinedFirst() == 1);
  $fields{last} = $self->GetLast() if ($self->DefinedLast() == 1);
  $fields{nick} = $self->GetNick() if ($self->DefinedNick() == 1);
  $fields{email} = $self->GetEmail() if ($self->DefinedEmail() == 1);
  $fields{address} = $self->GetAddress() if ($self->DefinedAddress() == 1);
  $fields{city} = $self->GetCity() if ($self->DefinedCity() == 1);
  $fields{state} = $self->GetState() if ($self->DefinedState() == 1);
  $fields{zip} = $self->GetZip() if ($self->DefinedZip() == 1);
  $fields{phone} = $self->GetPhone() if ($self->DefinedPhone() == 1);
  $fields{url} = $self->GetURL() if ($self->DefinedURL() == 1);
  $fields{date} = $self->GetDate() if ($self->DefinedDate() == 1);
  $fields{misc} = $self->GetMisc() if ($self->DefinedMisc() == 1);
  $fields{text} = $self->GetText() if ($self->DefinedText() == 1);
  $fields{key} = $self->GetKey() if ($self->DefinedKey() == 1);

  return \%fields;
}


##############################################################################
#
# SetRegister - takes a hash of all of the things you can set on an register
#               <query/> and sets each one.
#
##############################################################################
sub SetRegister {
  shift;
  my $self = shift;
  my %register;
  while($#_ >= 0) { $register{ lc pop(@_) } = pop(@_); }
  
  $self->SetInstructions($register{instructions}) if exists($register{instructions});

  $self->SetUsername($register{username}) if exists($register{username});
  $self->SetPassword($register{password}) if exists($register{password});
  $self->SetName($register{name}) if exists($register{name});
  $self->SetFirst($register{first}) if exists($register{first});
  $self->SetLast($register{last}) if exists($register{last});
  $self->SetNick($register{nick}) if exists($register{nick});
  $self->SetEmail($register{email}) if exists($register{email});
  $self->SetAddress($register{address}) if exists($register{address});
  $self->SetCity($register{city}) if exists($register{city});
  $self->SetState($register{state}) if exists($register{state});
  $self->SetZip($register{zip}) if exists($register{zip});
  $self->SetPhone($register{phone}) if exists($register{phone});
  $self->SetURL($register{url}) if exists($register{url});
  $self->SetDate($register{date}) if exists($register{date});
  $self->SetMisc($register{misc}) if exists($register{misc});
  $self->SetText($register{text}) if exists($register{text});
  $self->SetKey($register{key}) if exists($register{key});
  $self->SetRemove() if exists($register{remove});
  $self->SetRegistered() if exists($register{registered});
}


1;
