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

    $username = $register->GetUsername();
    $password = $register->GetPassword();
    $name     = $register->GetName();
    $email    = $register->GetEmail();
    $address  = $register->GetAddress();
    $city     = $register->GetCity();
    $state    = $register->GetState();
    $zip      = $register->GetZip();
    $phone    = $register->GetPhone();
    $url      = $register->GetURL();
    $date     = $register->GetDate();
    $misc     = $register->GetMisc();
    $text     = $register->GetText();
    $key      = $register->GetKey();
    $remove   = $register->GetRemove();

    %fields = $register->GetFields();

=head2 Client Creation functions

    $register->SetRegister(username=>'test',
                           password=>'user',
                           name=>'Test Account');

    $register->SetUsername('bob');
    $register->SetPassword('bobrulez');
    $register->SetName('Bob the Great');
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

=head2 Test functions

    $test = $register->DefinedUsername();
    $test = $register->DefinedPassword();
    $test = $register->DefinedName();
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

=head1 METHODS

=head2 Retrieval functions

  GetInstructions() - returns a string with the instructions in the <query/>.

  GetUsername() - returns a string with the username in the <query/>.

  GetPassword() - returns a string with the password in the <query/>.

  GetName() - returns a string with the name in the <query/>.

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

  GetFields() -  returns a hash with the keys being the fields
                 contained in the <query/> and the values the
                 contents of the tags.

=head2 Creation functions

  SetRegister(instructions=>string, - set multiple fields in the <iq/>
	      username=>string,       at one time.  This is a cumulative
              password=>string,       and over writing action.  If you
              name=>string,           set the "username" twice, the second
              email=>string,          setting is what is used.  If you set
              address=>string,        the password, and then set the 
              city=>string,           name then both will be in the
              state=>string,          <query/> tag.  For valid settings
              zip=>string,            read  the specific Set functions below.
              phone=>string,
              url=>string,
              date=>string,
              misc=>string,
              text=>string,
              key=>string,
              remove=>string)
 
  SetUsername(string) - sets the username for the account you are
                        trying to create.  Set string to "" to send
                        <username/> for instructions.

  SetPassword(string) - sets the password for the account you are
                        trying to create.  Set string to "" to send
                        <password/> for instructions.

  SetName(string) - sets the name for the account you are
                    trying to create.  Set string to "" to send
                    <name/> for instructions.

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

  SetRemove() - sets the remove for the account you are
                trying to create so that the account will
                be removed from the server/transport.

=head2 Test functions

  DefinedUsername() - returns 1 if there is a <username/> in the query,
                      0 if not.

  DefinedPassword() - returns 1 if there is a <password/> in the query,
                      0 if not.

  DefinedName() - returns 1 if there is a <name/> in the query,
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

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION);

$VERSION = "1.0";

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
# GetInstructions - returns the instructions in the <query/>.
#
##############################################################################
sub GetInstructions {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"instructions");
}


##############################################################################
#
# GetUsername - returns the username in the <query/>.
#
##############################################################################
sub GetUsername {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"username");
}


##############################################################################
#
# GetPassword - returns the password in the <query/>.
#
##############################################################################
sub GetPassword {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"password");
}


##############################################################################
#
# GetName - returns the name in the <query/>.
#
##############################################################################
sub GetName {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"name");
}


##############################################################################
#
# GetEmail - returns the email in the <query/>.
#
##############################################################################
sub GetEmail {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"email");
}


##############################################################################
#
# GetAddress - returns the address in the <query/>.
#
##############################################################################
sub GetAddress {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"address");
}


##############################################################################
#
# GetCity - returns the city in the <query/>.
#
##############################################################################
sub GetCity {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"city");
}


##############################################################################
#
# GetState - returns the state in the <query/>.
#
##############################################################################
sub GetState {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"state");
}


##############################################################################
#
# GetZip - returns the zip in the <query/>.
#
##############################################################################
sub GetZip {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"zip");
}


##############################################################################
#
# GetPhone - returns the phone in the <query/>.
#
##############################################################################
sub GetPhone {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"phone");
}


##############################################################################
#
# GetURL - returns the url in the <query/>.
#
##############################################################################
sub GetURL {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"url");
}


##############################################################################
#
# GetDate - returns the date in the <query/>.
#
##############################################################################
sub GetDate {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"date");
}


##############################################################################
#
# GetMisc - returns the misc in the <query/>.
#
##############################################################################
sub GetMisc {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"misc");
}


##############################################################################
#
# GetText - returns the text in the <query/>.
#
##############################################################################
sub GetText {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"text");
}


##############################################################################
#
# GetKey - returns the key in the <query/>.
#
##############################################################################
sub GetKey {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"key");
}


##############################################################################
#
# GetRemove - returns the remove in the <query/>.
#
##############################################################################
sub GetRemove {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{QUERY},"remove");
}


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
  $fields{remove} = $self->GetRemove() if ($self->DefinedRemove() == 1);

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
  $self->SetRemove($register{remove}) if exists($register{remove});
}


##############################################################################
#
# SetInstructions - sets the instructions result register
#
##############################################################################
sub SetInstructions {
  shift;
  my $self = shift;
  my ($instructions) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"instructions",$instructions,{});
}


##############################################################################
#
# SetUsername - sets the username of the account you want to connect with.
#
##############################################################################
sub SetUsername {
  shift;
  my $self = shift;
  my ($username) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"username",$username,{});
}


##############################################################################
#
# SetPassword - sets the password of the account you want to connect with.
#
##############################################################################
sub SetPassword {
  shift;
  my $self = shift;
  my ($password) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"password",$password,{});
}


##############################################################################
#
# SetName - sets the name of the account you want to connect with.
#
##############################################################################
sub SetName {
  shift;
  my $self = shift;
  my ($name) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"name",$name,{});
}


##############################################################################
#
# SetEmail - sets the email of the account you want to connect with.
#
##############################################################################
sub SetEmail {
  shift;
  my $self = shift;
  my ($email) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"email",$email,{});
}


##############################################################################
#
# SetAddress - sets the address of the account you want to connect with.
#
##############################################################################
sub SetAddress {
  shift;
  my $self = shift;
  my ($address) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"address",$address,{});
}


##############################################################################
#
# SetCity - sets the city of the account you want to connect with.
#
##############################################################################
sub SetCity {
  shift;
  my $self = shift;
  my ($city) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"city",$city,{});
}


##############################################################################
#
# SetState - sets the state of the account you want to connect with.
#
##############################################################################
sub SetState {
  shift;
  my $self = shift;
  my ($state) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"state",$state,{});
}


##############################################################################
#
# SetZip - sets the zip of the account you want to connect with.
#
##############################################################################
sub SetZip {
  shift;
  my $self = shift;
  my ($zip) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"zip",$zip,{});
}


##############################################################################
#
# SetPhone - sets the phone of the account you want to connect with.
#
##############################################################################
sub SetPhone {
  shift;
  my $self = shift;
  my ($phone) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"phone",$phone,{});
}


##############################################################################
#
# SetURL - sets the url of the account you want to connect with.
#
##############################################################################
sub SetURL {
  shift;
  my $self = shift;
  my ($url) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"url",$url,{});
}


##############################################################################
#
# SetDate - sets the date of the account you want to connect with.
#
##############################################################################
sub SetDate {
  shift;
  my $self = shift;
  my ($date) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"date",$date,{});
}


##############################################################################
#
# SetMisc - sets the misc of the account you want to connect with.
#
##############################################################################
sub SetMisc {
  shift;
  my $self = shift;
  my ($misc) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"misc",$misc,{});
}


##############################################################################
#
# SetText - sets the text of the account you want to connect with.
#
##############################################################################
sub SetText {
  shift;
  my $self = shift;
  my ($text) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"text",$text,{});
}


##############################################################################
#
# SetKey - sets the key of the account you want to connect with.
#
##############################################################################
sub SetKey {
  shift;
  my $self = shift;
  my ($key) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"key",$key,{});
}


##############################################################################
#
# SetRemove - sets the remove of the account you want to connect with.
#
##############################################################################
sub SetRemove {
  shift;
  my $self = shift;
  my ($remove) = @_;
  &Net::Jabber::SetXMLData("single",$self->{QUERY},"remove",$remove,{});
}


##############################################################################
#
# DefinedInstructions - returns the instructions in the <query/>.
#
##############################################################################
sub DefinedInstructions {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"instructions");
}


##############################################################################
#
# DefinedUsername - returns the username in the <query/>.
#
##############################################################################
sub DefinedUsername {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"username");
}


##############################################################################
#
# DefinedPassword - returns the password in the <query/>.
#
##############################################################################
sub DefinedPassword {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"password");
}


##############################################################################
#
# DefinedName - returns the name in the <query/>.
#
##############################################################################
sub DefinedName {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"name");
}


##############################################################################
#
# DefinedEmail - returns the email in the <query/>.
#
##############################################################################
sub DefinedEmail {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"email");
}


##############################################################################
#
# DefinedAddress - returns the address in the <query/>.
#
##############################################################################
sub DefinedAddress {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"address");
}


##############################################################################
#
# DefinedCity - returns the city in the <query/>.
#
##############################################################################
sub DefinedCity {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"city");
}


##############################################################################
#
# DefinedState - returns the state in the <query/>.
#
##############################################################################
sub DefinedState {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"state");
}


##############################################################################
#
# DefinedZip - returns the zip in the <query/>.
#
##############################################################################
sub DefinedZip {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"zip");
}


##############################################################################
#
# DefinedPhone - returns the phone in the <query/>.
#
##############################################################################
sub DefinedPhone {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"phone");
}


##############################################################################
#
# DefinedURL - returns the url in the <query/>.
#
##############################################################################
sub DefinedURL {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"url");
}


##############################################################################
#
# DefinedDate - returns the date in the <query/>.
#
##############################################################################
sub DefinedDate {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"date");
}


##############################################################################
#
# DefinedMisc - returns the misc in the <query/>.
#
##############################################################################
sub DefinedMisc {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"misc");
}


##############################################################################
#
# DefinedText - returns the text in the <query/>.
#
##############################################################################
sub DefinedText {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"text");
}


##############################################################################
#
# DefinedKey - returns the key in the <query/>.
#
##############################################################################
sub DefinedKey {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"key");
}


##############################################################################
#
# DefinedRemove - returns the remove in the <query/>.
#
##############################################################################
sub DefinedRemove {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("existence",$self->{QUERY},"remove");
}


1;
