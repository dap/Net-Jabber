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

package Net::Jabber::XDB;

=head1 NAME

Net::Jabber::XDB - Jabber XDB Library

=head1 SYNOPSIS

  Net::Jabber::XDB is a companion to the Net::Jabber module. It
  provides the user a simple interface to set and retrieve all 
  parts of a Jabber XDB.

=head1 DESCRIPTION

  Net::Jabber::XDB differs from the other Net::Jabber::* modules in that
  the XMLNS of the data is split out into more submodules under
  XDB.  For specifics on each module please view the documentation
  for each Net::Jabber::Data::* module.  To see the list of avilable
  namspaces and modules see Net::Jabber::Data.

  To initialize the XDB with a Jabber <xdb/> you must pass it the 
  XML::Parser Tree array.  For example:

    my $xdb = new Net::Jabber::XDB(@tree);

  There has been a change from the old way of handling the callbacks.
  You no longer have to do the above, a Net::Jabber::XDB object is passed
  to the callback function for the xdb:

    use Net::Jabber;

    sub xdb {
      my ($XDB) = @_;
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new xdb to send to the server:

    use Net::Jabber;

    $XDB = new Net::Jabber::XDB();
    $XDBType = $XDB->NewData( type );
    $XDBType->SetXXXXX("yyyyy");

  Now you can call the creation functions for the XDB, and for the <data/>
  on the new Data object itself.  See below for the <xdb/> functions, and
  in each data module for those functions.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $to       = $XDB->GetTo();
    $toJID    = $XDB->GetTo("jid");
    $from     = $XDB->GetFrom();
    $fromJID  = $XDB->GetFrom("jid");
    $type     = $XDB->GetType();

    $data     = $XDB->GetData();
    $dataTree = $XDB->GetDataTree();

    $str      = $XDB->GetXML();
    @xdb     d  = $XDB->GetTree();

=head2 Creation functions

    $XDB->SetXDB(tYpE=>"get",
		 tO=>"bob@jabber.org");

    $XDB->SetTo("bob@jabber.org");
    $XDB->SetFrom("me\@jabber.org");
    $XDB->SetType("set");

    $XDBObject = $XDB->NewData("jabber:iq:auth");
    $XDBObject = $XDB->NewData("jabber:iq:roster");

    $xdbReply = $XDB->Reply();
    $xdbReply = $XDB->Reply("client");
    $xdbReply = $XDB->Reply("transport");

=head2 Test functions

    $test = $XDB->DefinedTo();
    $test = $XDB->DefinedFrom();
    $test = $XDB->DefinedType();

=head1 METHODS

=head2 Retrieval functions

  GetTo()      - returns either a string with the Jabber Identifier,
  GetTo("jid")   or a Net::Jabber::JID object for the person who is 
                 going to receive the <xdb/>.  To get the JID
                 object set the string to "jid", otherwise leave
                 blank for the text string.

  GetFrom()      -  returns either a string with the Jabber Identifier,
  GetFrom("jid")    or a Net::Jabber::JID object for the person who
                    sent the <xdb/>.  To get the JID object set 
                    the string to "jid", otherwise leave blank for the 
                    text string.

  GetType() - returns a string with the type <xdb/> this is.

  GetData() - returns a Net::Jabber::Data object that contains the data
               in the <data/> of the <xdb/>.

  GetDataTree() - returns an XML::Parser::Tree object that contains the 
                   data in the <data/> of the <xdb/>.

  GetXML() - returns the XML string that represents the <xdb/>. This 
             is used by the Send() function in Client.pm to send
             this object as a Jabber XDB.

  GetTree() - returns an array that contains the <xdb/> tag in XML::Parser 
              Tree format.

=head2 Creation functions

  SetXDB(to=>string|JID,    - set multiple fields in the <xdb/> at one
         from=>string|JID,    time.  This is a cumulative and over
         id=>string,          writing action.  If you set the "to"
         type=>string,        attribute twice, the second setting is
         errorcode=>string,   what is used.  If you set the status, and
         error=>string)       then set the priority then both will be in
                              the <xdb/> tag.  For valid settings read the
                              specific Set functions below.

  SetTo(string) - sets the to attribute.  You can either pass a string
  SetTo(JID)      or a JID object.  They must be a valid Jabber 
                  Identifiers or the server will return an error message.
                  (ie.  jabber:bob@jabber.org, etc...)

  SetFrom(string) - sets the from attribute.  You can either pass a string
  SetFrom(JID)      or a JID object.  They must be a valid Jabber 
                    Identifiers or the server will return an error message.
                    (ie.  jabber:bob@jabber.org, etc...)

  SetType(string) - sets the type attribute.  Valid settings are:

                    get      request information
                    set      set information
                    result   results of a get

  NewData(string) - creates a new Net::Jabber::Data object with the 
                     namespace in the string.  In order for this function 
                     to work with a custom namespace, you must define and 
                     register that namespace with the XDB module.  For more 
                     information please read the documentation for 
                     Net::Jabber::Data.  NOTE: Jabber does not support
                     custom XDBs at the time of this writing.  This was just
                     including in case they do at some point.

  Reply(type=>string) - creates a new XDB object and populates the to/from
                        fields.  The type will be set in the <xdb/>.

=head2 Test functions

  DefinedTo() - returns 1 if the to attribute is defined in the <xdb/>, 
                0 otherwise.

  DefinedFrom() - returns 1 if the from attribute is defined in the <xdb/>, 
                  0 otherwise.

  DefinedType() - returns 1 if the type attribute is defined in the <xdb/>, 
                  0 otherwise.

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

$VERSION = "1.0020";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  $self->{DEBUG} = new Net::Jabber::Debug(usedefault=>1,
					  header=>"NJ::XDB");
  
  $self->{DATA} = "";

  if ("@_" ne ("")) {
    if (ref($_[0]) eq "Net::Jabber::XDB") {
      return $_[0];
    } else {
      my @temp = @_;
      $self->{XDB} = \@temp;
      my $xmlns = $self->GetDataXMLNS();
      if (exists($Net::Jabber::DELEGATES{data}->{$xmlns})) {
	my @dataTree = $self->GetDataTree();
	$self->SetData($xmlns,@dataTree) if ($xmlns ne "");
      }
    }
  } else {
    $self->{XDB} = [ "xdb" , [{}]];
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
  my $treeName = "XDB";
  
  return "xdb" if ($AUTOLOAD eq "GetTag");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{To}         = ["value","","to"];
$FUNCTIONS{get}->{From}       = ["value","","from"];
$FUNCTIONS{get}->{Type}       = ["value","","type"];

$FUNCTIONS{set}->{Type}       = ["single","","","type","*"];

$FUNCTIONS{defined}->{To}         = ["existence","","to"];
$FUNCTIONS{defined}->{From}       = ["existence","","from"];
$FUNCTIONS{defined}->{Type}       = ["existence","","type"];


##############################################################################
#
# GetData - returns a Net::Jabber::Data object that contains the <data/>
#
##############################################################################
sub GetData {
  my $self = shift;
  $self->{DEBUG}->Log2("GetData: return($self->{DATA})");
  return $self->{DATA} if ($self->{DATA} ne "");
  return;
}


##############################################################################
#
# GetDataTree - returns an XML::Parser::Tree object of the <data/> tag
#
##############################################################################
sub GetDataTree {
  my $self = shift;
  $self->MergeData();
  my @data = &Net::Jabber::GetXMLData("tree",$self->{XDB},"","");
  &Net::Jabber::printData("\$data",\@data);
}


##############################################################################
#
# GetDataXMLNS - returns the xmlns of the <data/> tag
#
##############################################################################
sub GetDataXMLNS {
  my $self = shift;
  $self->MergeData();

  if ($self->GetType() eq "result") {
    my $fromJID = $self->GetFrom("jid");
    return $fromJID->GetResource();
  }
  if (($self->GetType() eq "") ||
      ($self->GetType() eq "get") ||
      ($self->GetType() eq "set")) {
    my $toJID = $self->GetTo("jid");
    return $toJID->GetResource();
  }
  return;
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  $self->MergeData();
  return &Net::Jabber::BuildXML(@{$self->{XDB}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;
  $self->MergeData();
  return @{$self->{XDB}};
}


##############################################################################
#
# SetXDB - takes a hash of all of the things you can set on an <xdb/> and sets
#         each one.
#
##############################################################################
sub SetXDB {
  my $self = shift;
  my %xdb;
  while($#_ >= 0) { $xdb{ lc pop(@_) } = pop(@_); }

  $self->SetTo($xdb{to}) if exists($xdb{to});
  $self->SetFrom($xdb{from}) if exists($xdb{from});
  $self->SetType($xdb{type}) if exists($xdb{type});
}


##############################################################################
#
# SetTo - sets the to attribute in the <xdb/>
#
##############################################################################
sub SetTo {
  my $self = shift;
  my ($to) = @_;
  if (ref($to) eq "Net::Jabber::JID") {
    $to = $to->GetJID("full");
  }
  return unless ($to eq "");
  &Net::Jabber::SetXMLData("single",$self->{XDB},"","",{to=>$to});
}


##############################################################################
#
# SetFrom - sets the from attribute in the <xdb/>
#
##############################################################################
sub SetFrom {
  my $self = shift;
  my ($from) = @_;
  if (ref($from) eq "Net::Jabber::JID") {
    $from = $from->GetJID("full");
  }
  return unless ($from ne "");
  &Net::Jabber::SetXMLData("single",$self->{XDB},"","",{from=>$from});
}


##############################################################################
#
# NewData - calls SetData to create a new Net::Jabber::Data object, sets 
#            the xmlns and returns a pointer to the new object.
#
##############################################################################
sub NewData {
  my $self = shift;
  my ($xmlns) = @_;
  return if !exists($Net::Jabber::DELEGATES{data}->{$xmlns});
  my $data = $self->SetData($xmlns);
  $data->SetXMLNS($xmlns) if $xmlns ne "";
  return $data;
}


##############################################################################
#
# SetData - creates a new Net::Jabber::Data object, sets the internal
#            pointer to it, and returns a pointer to the new object.  This 
#            is a private helper function.
#
##############################################################################
sub SetData {
  my $self = shift;
  my ($xmlns,@dataTree) = @_;
  return if !exists($Net::Jabber::DELEGATES{data}->{$xmlns});
  $self->{DEBUG}->Log2("SetData: xmlns($xmlns) tree(",\@dataTree,")");
  eval("\$self->{DATA} = new ".$Net::Jabber::DELEGATES{data}->{$xmlns}->{parent}."(\@dataTree);");
  $self->{DEBUG}->Log2("SetData: return($self->{DATA})");
  return $self->{DATA};
}
  

##############################################################################
#
# MergeData - rebuilds the <data/>in memory and merges it into the current
#              XDB tree. This is a private helper function.  It should be used
#              any time you need access the full <xdb/> so that the <data/> 
#              tag is included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeData {
  my $self = shift;

  $self->{DEBUG}->Log2("MergeData: start");

  my $replaced = 0;

  return if ($self->{DATA} eq "");

  $self->{DEBUG}->Log2("MergeData: selfData($self->{DATA})");

  my $data = $self->{DATA};
  my @dataTree = $data->GetTree();

  $self->{DEBUG}->Log2("MergeData: Check the old tags");
  $self->{DEBUG}->Log2("MergeData: length(",$#{$self->{XDB}->[1]},")");

  my $i;
  foreach $i (1..$#{$self->{XDB}->[1]}) {
    $self->{DEBUG}->Log2("MergeData: i($i)");
    $self->{DEBUG}->Log2("MergeData: data(",$self->{XDB}->[1]->[$i],")");
    if ((ref($self->{XDB}->[1]->[($i+1)]) eq "ARRAY") &&
	exists($self->{XDB}->[1]->[($i+1)]->[0]->{xmlns})) {
      $replaced = 1;
      $self->{XDB}->[1]->[$i] = $dataTree[0];
      $self->{XDB}->[1]->[($i+1)] = $dataTree[1];
    }
  }

  if ($replaced == 0) {
    $self->{DEBUG}->Log2("MergeData: new tag");
    $self->{XDB}->[1]->[($#{$self->{XDB}->[1]}+1)] = $dataTree[0];
    $self->{XDB}->[1]->[($#{$self->{XDB}->[1]}+1)] = $dataTree[1];
  }

  $self->{DEBUG}->Log2("MergeData: end");
}


##############################################################################
#
# Reply - returns a Net::Jabber::XDB object with the proper fields
#         already populated for you.
#
##############################################################################
sub Reply {
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $reply = new Net::Jabber::XDB();

  $reply->SetID($self->GetID()) if ($self->GetID() ne "");
  $reply->SetType(exists($args{type}) ? $args{type} : "result");

  my $selfData = $self->GetData();
  $reply->NewData($selfData->GetXMLNS());
  
  $reply->SetXDB(to=>$self->GetFrom(),
		 from=>$self->GetTo(),
		);

  return $reply;
}


1;
