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

package Net::Jabber::IQ;

=head1 NAME

Net::Jabber::IQ - Jabber Info/Query Library

=head1 SYNOPSIS

  Net::Jabber::IQ is a companion to the Net::Jabber module. It
  provides the user a simple interface to set and retrieve all
  parts of a Jabber IQ.

=head1 DESCRIPTION

  Net::Jabber::IQ differs from the other Net::Jabber::* modules in that
  the XMLNS of the query is split out into a submodule under
  IQ.  For specifics on each module please view the documentation
  for the Net::Jabber::Query module.

  To initialize the IQ with a Jabber <iq/> you must pass it the
  XML::Stream hash.  For example:

    my $iq = new Net::Jabber::IQ(%hash);

  There has been a change from the old way of handling the callbacks.
  You no longer have to do the above yourself, a Net::Jabber::IQ
  object is passed to the callback function for the message.  Also,
  the first argument to the callback functions is the session ID from
  XML::Streams.  There are some cases where you might want this
  information, like if you created a Client that connects to two servers
  at once, or for writing a mini server.

    use Net::Jabber qw(Client);

    sub iq {
      my ($sid,$IQ) = @_;
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new iq to send to the server:

    use Net::Jabber qw(Client);

    $IQ = new Net::Jabber::IQ();
    $IQType = $IQ->NewQuery( type );
    $IQType->SetXXXXX("yyyyy");

  Now you can call the creation functions for the IQ, and for the <query/>
  on the new Query object itself.  See below for the <iq/> functions, and
  in each query module for those functions.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head1 METHODS

=head2 Retrieval functions

  GetTo()      - returns either a string with the Jabber Identifier,
  GetTo("jid")   or a Net::Jabber::JID object for the person who is
                 going to receive the <iq/>.  To get the JID
                 object set the string to "jid", otherwise leave
                 blank for the text string.

                 $to    = $IQ->GetTo();
                 $toJID = $IQ->GetTo("jid");

  GetFrom()      -  returns either a string with the Jabber Identifier,
  GetFrom("jid")    or a Net::Jabber::JID object for the person who
                    sent the <iq/>.  To get the JID object set
                    the string to "jid", otherwise leave blank for the
                    text string.

                    $from    = $IQ->GetFrom();
                    $fromJID = $IQ->GetFrom("jid");

  GetType() - returns a string with the type <iq/> this is.

              $type = $IQ->GetType();

  GetID() - returns an integer with the id of the <iq/>.

            $id = $IQ->GetID();

  GetError() - returns a string with the text description of the error.

               $error = $IQ->GetError();

  GetErrorCode() - returns a string with the code of error.

                   $errorCode = $IQ->GetErrorCode();

  GetQuery() - returns a Net::Jabber::Query object that contains the data
               in the <query/> of the <iq/>.

               $queryTag = $IQ->GetQuery();

  GetQueryXMLNS() - returns a string with the namespace of the query
                    for this <iq/>, if one exists.

                    $xmlns = $IQ->GetQueryXMLNS();

=head2 Creation functions

  SetIQ(to=>string|JID,    - set multiple fields in the <iq/> at one
        from=>string|JID,    time.  This is a cumulative and over
        id=>string,          writing action.  If you set the "to"
        type=>string,        attribute twice, the second setting is
        errorcode=>string,   what is used.  If you set the status, and
        error=>string)       then set the priority then both will be in
                             the <iq/> tag.  For valid settings read the
                             specific Set functions below.

                             $IQ->SetIQ(type=>"get",
					to=>"bob\@jabber.org",
					query=>"info");

                             $IQ->SetIQ(to=>"bob\@jabber.org",
					errorcode=>403,
					error=>"Permission Denied");

  SetTo(string) - sets the to attribute.  You can either pass a string
  SetTo(JID)      or a JID object.  They must be a valid Jabber
                  Identifiers or the server will return an error message.
                  (ie.  jabber:bob@jabber.org, etc...)

                 $IQ->SetTo("bob\@jabber.org");

  SetFrom(string) - sets the from attribute.  You can either pass a string
  SetFrom(JID)      or a JID object.  They must be a valid Jabber
                    Identifiers or the server will return an error message.
                    (ie.  jabber:bob@jabber.org, etc...)

                    $IQ->SetFrom("me\@jabber.org");

  SetType(string) - sets the type attribute.  Valid settings are:

                    get      request information
                    set      set information
                    result   results of a get
                    error    there was an error

                    $IQ->SetType("set");

  SetErrorCode(string) - sets the error code of the <iq/>.

                         $IQ->SetErrorCode(403);

  SetError(string) - sets the error string of the <iq/>.

                     $IQ->SetError("Permission Denied");

  NewQuery(string) - creates a new Net::Jabber::Query object with the
                     namespace in the string.  In order for this function
                     to work with a custom namespace, you must define and
                     register that namespace with the IQ module.  For more
                     information please read the documentation for
                     Net::Jabber::Query.

                     $queryObj = $IQ->NewQuery("jabber:iq:auth");
                     $queryObj = $IQ->NewQuery("jabber:iq:roster");

  Reply(hash) - creates a new IQ object and populates the to/from
                fields.  If you specify a hash the same as with SetIQ
                then those values will override the Reply values.

                $iqReply = $IQ->Reply();
                $iqReply = $IQ->Reply(type=>"result");

=head2 Test functions

  DefinedTo() - returns 1 if the to attribute is defined in the <iq/>, 
                0 otherwise.

                $test = $IQ->DefinedTo();

  DefinedFrom() - returns 1 if the from attribute is defined in the <iq/>, 
                  0 otherwise.

                  $test = $IQ->DefinedFrom();

  DefinedID() - returns 1 if the id attribute is defined in the <iq/>, 
                0 otherwise.

                $test = $IQ->DefinedID();

  DefinedType() - returns 1 if the type attribute is defined in the <iq/>, 
                  0 otherwise.

                  $test = $IQ->DefinedType();

  DefinedError() - returns 1 if <error/> is defined in the <iq/>, 
                   0 otherwise.

                   $test = $IQ->DefinedError();

  DefinedErrorCode() - returns 1 if the code attribute is defined in
                       <error/>, 0 otherwise.

                       $test = $IQ->DefinedErrorCode();

=head1 AUTHOR

By Ryan Eatmon in May of 2001 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.26";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };

  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  $self->{DEBUGHEADER} = "IQ";

  $self->{DATA} = {};
  $self->{CHILDREN} = {};

  $self->{TAG} = "iq";

  if ("@_" ne ("")) {
    if (ref($_[0]) eq "Net::Jabber::IQ") {
      return $_[0];
    } else {
      $self->{TREE} = shift;
      $self->ParseTree();
      delete($self->{TREE});
    }
  }

  return $self;
}


##############################################################################
#
# AUTOLOAD - This function calls the main AutoLoad function in Jabber.pm
#
##############################################################################
sub AUTOLOAD {
  my $self = shift;
  &Net::Jabber::AutoLoad($self,$AUTOLOAD,@_);
}

$FUNCTIONS{Error}->{Get}        = "error";
$FUNCTIONS{Error}->{Set}        = ["scalar","error"];
$FUNCTIONS{Error}->{Defined}    = "error";
$FUNCTIONS{Error}->{Hash}       = "child-data";

$FUNCTIONS{ErrorCode}->{Get}        = "errorcode";
$FUNCTIONS{ErrorCode}->{Set}        = ["scalar","errorcode"];
$FUNCTIONS{ErrorCode}->{Defined}    = "errorcode";
$FUNCTIONS{ErrorCode}->{Hash}       = "att-error-code";

$FUNCTIONS{From}->{Get}        = "from";
$FUNCTIONS{From}->{Set}        = ["jid","from"];
$FUNCTIONS{From}->{Defined}    = "from";
$FUNCTIONS{From}->{Hash}       = "att";

$FUNCTIONS{ID}->{Get}        = "id";
$FUNCTIONS{ID}->{Set}        = ["scalar","id"];
$FUNCTIONS{ID}->{Defined}    = "id";
$FUNCTIONS{ID}->{Hash}       = "att";

$FUNCTIONS{To}->{Get}        = "to";
$FUNCTIONS{To}->{Set}        = ["jid","to"];
$FUNCTIONS{To}->{Defined}    = "to";
$FUNCTIONS{To}->{Hash}       = "att";

$FUNCTIONS{Type}->{Get}        = "type";
$FUNCTIONS{Type}->{Set}        = ["scalar","type"];
$FUNCTIONS{Type}->{Defined}    = "type";
$FUNCTIONS{Type}->{Hash}       = "att";

$FUNCTIONS{Query}->{Get}        = "__netjabber__:children:query";
$FUNCTIONS{Query}->{Defined}    = "__netjabber__:children:query";

$FUNCTIONS{X}->{Get}     = "__netjabber__:children:x";
$FUNCTIONS{X}->{Defined} = "__netjabber__:children:x";

$FUNCTIONS{IQ}->{Get} = "__netjabber__:master";
$FUNCTIONS{IQ}->{Set} = ["master"];


##############################################################################
#
# GetQueryXMLNS - returns the xmlns of the <query/> tag
#
##############################################################################
sub GetQueryXMLNS {
  my $self = shift;
  return $self->{CHILDREN}->{query}->[0]->GetXMLNS() if exists($self->{CHILDREN}->{query});
}


##############################################################################
#
# Reply - returns a Net::Jabber::IQ object with the proper fields
#         already populated for you.
#
##############################################################################
sub Reply {
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $reply = new Net::Jabber::IQ();

  $reply->SetID($self->GetID()) if ($self->GetID() ne "");
  $reply->SetType("result");

  $reply->AddQuery($self->GetQuery());

  $reply->SetIQ(to=>$self->GetFrom(),
		from=>$self->GetTo(),
		%args
	       );

  return $reply;
}


1;
