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

package Net::Jabber::Dialback::Verify;

=head1 NAME

Net::Jabber::Dialback::Verify - Jabber Dialback Verify Module

=head1 SYNOPSIS

  Net::Jabber::Dialback::Verify is a companion to the Net::Jabber::Dialback 
  module.  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber Dialback Verify.

=head1 DESCRIPTION

  To initialize the Verify with a Jabber <log/> you must pass it the 
  XML::Parse::Tree array.  For example:

    my $dialback = new Net::Jabber::Dialback::Verify(@tree);

  There has been a change from the old way of handling the callbacks.
  You no longer have to do the above, a Net::Jabber::Dialback::Verify 
  object is passed to the callback function for the dialback:

    use Net::Jabber;

    sub dialback {
      my ($Verify) = @_;
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new dialback to send to the server:

    use Net::Jabber;

    $Verify = new Net::Jabber::Dialback::Verify();

  Now you can call the creation functions below to populate the tag before
  sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $to         = $Verify->GetTo();
    $from       = $Verify->GetFrom();
    $type       = $Verify->GetType();
    $id         = $Verify->GetID();
    $data       = $Verify->GetData();

    $str        = $Verify->GetXML();
    @dialback   = $Verify->GetTree();

=head2 Creation functions

    $Verify->SetVerify(from=>"jabber.org",
		       to=>"jabber.com",
		       id=>id,
		       data=>key);
    $Verify->SetTo("jabber.org");
    $Verify->SetFrom("jabber.com");
    $Verify->SetType("valid");
    $Verify->SetID(id);
    $Verify->SetData(key);

=head2 Test functions

    $test = $Verify->DefinedTo();
    $test = $Verify->DefinedFrom();
    $test = $Verify->DefinedType();
    $test = $Verify->DefinedID();

=head1 METHODS

=head2 Retrieval functions

  GetTo() -  returns a string with server that the <db:verify/> is being
             sent to.

  GetFrom() -  returns a string with server that the <db:verify/> is being
               sent from.

  GetType() - returns a string with the type <db:verify/> this is.

  GetID() - returns a string with the id <db:verify/> this is.

  GetData() - returns a string with the cdata of the <db:verify/>.

  GetXML() - returns the XML string that represents the <db:verify/>.
             This is used by the Send() function in Server.pm to send
             this object as a Jabber Dialback Verify.

  GetTree() - returns an array that contains the <db:verify/> tag
              in XML::Parser::Tree format.

=head2 Creation functions

  SetVerify(to=>string,   - set multiple fields in the <db:verify/>
            from=>string,   at one time.  This is a cumulative
            type=>string,   and over writing action.  If you set
            id=>string,     the "from" attribute twice, the second
            data=>string)   setting is what is used.  If you set
                            the type, and then set the data
                            then both will be in the <db:verify/>
                            tag.  For valid settings read the
                            specific Set functions below.

  SetTo(string) - sets the to attribute.

  SetFrom(string) - sets the from attribute.

  SetType(string) - sets the type attribute.  Valid settings are:

                    valid
                    invalid

  SetID(string) - sets the id attribute.

  SetData(string) - sets the cdata of the <db:verify/>.

=head2 Test functions

  DefinedTo() - returns 1 if the to attribute is defined in the 
                <db:verify/>, 0 otherwise.

  DefinedFrom() - returns 1 if the from attribute is defined in the 
                  <db:verify/>, 0 otherwise.

  DefinedType() - returns 1 if the type attribute is defined in the 
                  <db:verify/>, 0 otherwise.

  DefinedID() - returns 1 if the id attribute is defined in the 
                  <db:verify/>, 0 otherwise.

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org..

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
  $self->{TIMESTAMP} = &Net::Jabber::GetTimeStamp("local");

  bless($self, $proto);

  $self->{DEBUG} = new Net::Jabber::Debug(usedefault=>1,
                                          header=>"NJ::Dialback::Verify");

  if ("@_" ne ("")) {
    if (ref($_[0]) eq "Net::Jabber::Dialback::Verify") {
      return $_[0];
    } else {
      my @temp = @_;
      $self->{DBVERIFY} = \@temp;
    }
  } else {
    $self->{DBVERIFY} = [ "db:verify" , [{}]];
  }

  return $self;
}


##############################################################################
#
# AUTOLOAD - This function calls the delegate with the appropriate function
#            name and argument list.
#
##############################################################################
sub AUTOLOAD {
  my $self = shift;
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = "DBVERIFY";
  
  return "dialback" if ($AUTOLOAD eq "GetTag");
  return &Net::Jabber::BuildXML(@{$self->{$treeName}}) if ($AUTOLOAD eq "GetXML");
  return @{$self->{$treeName}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{To}   = ["value","","to"];
$FUNCTIONS{get}->{From} = ["value","","from"];
$FUNCTIONS{get}->{Type} = ["value","","type"];
$FUNCTIONS{get}->{ID} = ["value","","id"];
$FUNCTIONS{get}->{Data} = ["value","",""];

$FUNCTIONS{set}->{Type} = ["single","","","type","*"];
$FUNCTIONS{set}->{ID} = ["single","","","id","*"];
$FUNCTIONS{set}->{Data} = ["single","","*","",""];

$FUNCTIONS{defined}->{To}   = ["existence","","to"];
$FUNCTIONS{defined}->{From} = ["existence","","from"];
$FUNCTIONS{defined}->{Type} = ["existence","","type"];
$FUNCTIONS{defined}->{ID} = ["existence","","id"];


##############################################################################
#
# SetVerify - takes a hash of all of the things you can set on a <dialback/>
#              and sets each one.
#
##############################################################################
sub SetVerify {
  my $self = shift;
  my %dbverify;
  while($#_ >= 0) { $dbverify{ lc pop(@_) } = pop(@_); }

  $self->SetTo($dbverify{to}) if exists($dbverify{to});
  $self->SetFrom($dbverify{from}) if exists($dbverify{from});
  $self->SetType($dbverify{type}) if exists($dbverify{type});
  $self->SetID($dbverify{id}) if exists($dbverify{id});
  $self->SetData($dbverify{data}) if exists($dbverify{data});
}


##############################################################################
#
# SetTo - sets the to attribute in the <db:verify/>
#
##############################################################################
sub SetTo {
  my $self = shift;
  my ($to) = @_;
  if (ref($to) eq "Net::Jabber::JID") {
    $to = $to->GetJID("full");
  }
  return unless ($to ne "");
  &Net::Jabber::SetXMLData("single",$self->{DBVERIFY},"","",{to=>$to});
}


##############################################################################
#
# SetFrom - sets the from attribute in the <db:verify/>
#
##############################################################################
sub SetFrom {
  my $self = shift;
  my ($from) = @_;
  if (ref($from) eq "Net::Jabber::JID") {
    $from = $from->GetJID("full");
  }
  return unless ($from ne "");
  &Net::Jabber::SetXMLData("single",$self->{DBVERIFY},"","",{from=>$from});
}


1;
