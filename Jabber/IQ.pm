package Net::Jabber::IQ;

=head1 NAME

Net::Jabber::IQ - Jabber Info/Query Library

=head1 SYNOPSIS

  Net::Jabber::IQ is a companion to the Net::Jabber module. It
  provides the user a simple interface to set and retrieve all 
  parts of a Jabber IQ.

=head1 DESCRIPTION

  Net::Jabber::IQ differs from the other Net::Jabber::* modules in that
  the XMLNS of the query is split out into more submodules under
  IQ.  For specifics on each module please view the documentation
  for each Net::Jabber::Query::* module.  The available modules are:

    Net::Jabber::Query::Auth      - Simple Client Authentication
    Net::Jabber::Query::Info      - Generic Info and Profile query
    Net::Jabber::Query::Register  - Registration requests
    Net::Jabber::Query::Resource  - User Resource Management
    Net::Jabber::Query::Roster    - Buddy List management

  To initialize the IQ with a Jabber <iq/> you must pass it the 
  XML::Parser Tree array from the Net::Jabber::Client module.  In the
  callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new iq to send to the server:

    use Net::Jabber;

    $IQ = new Net::Jabber::IQ();
    $IQType = $IQ->NewQuery( type );
    $IQType->SetXXXXX("yyyyy");

  Now you can call the creation functions for the IQ, and for the <query/>
  on the new Query object itself.  See below for the <iq/> functions, and
  in each query module for those functions.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $to        = $IQ->GetTo();
    $toJID     = $IQ->GetTo("jid");
    $from      = $IQ->GetFrom();
    $fromJID   = $IQ->GetFrom("jid");
    $id        = $IQ->GetID();
    $type      = $IQ->GetType();
    $error     = $IQ->GetError();
    $errorType = $IQ->GetErrorType();

    $queryTag  = $IQ->GetQuery();
    $qureyTree = $IQ->GetQueryTree();

    $str       = $IQ->GetXML();
    @iq        = $IQ->GetTree();

=head2 Creation functions

    $IQ->SetIQ(tYpE=>"get",
	       tO=>"bob@jabber.org",
	       query=>"info");

    $IQ->SetTo("bob@jabber.org");
    $IQ->SetType("set");

    $IQ->SetIQ(to=>"bob\@jabber.org",
               errortype=>"denied",
               error=>"Permission Denied");
    $IQ->SetErrorType("denied");
    $IQ->SetError("Permission Denied");

    $IQObject = $IQ->NewQuery("jabber:iq:auth");
    $IQObject = $IQ->NewQuery("jabber:iq:roster");

=head1 METHODS

=head2 Retrieval functions

  GetTo()      - returns either a string with the Jabber Identifier,
  GetTo("jid")   or a Net::Jabber::JID object for the person who is 
                 going to receive the <iq/>.  To get the JID
                 object set the string to "jid", otherwise leave
                 blank for the text string.

  GetFrom()      -  returns either a string with the Jabber Identifier,
  GetFrom("jid")    or a Net::Jabber::JID object for the person who
                    sent the <iq/>.  To get the JID object set 
                    the string to "jid", otherwise leave blank for the 
                    text string.

  GetType() - returns a string with the type <iq/> this is.

  GetID() - returns an integer with the id of the <iq/>.

  GetError() - returns a string with the text description of the error.

  GetErrorType() - returns a string with the type of error.

  GetQuery() - returns a Net::Jabber::Query object that contains the data
               in the <query/> of the <iq/>.

  GetQueryTree() - returns an XML::Parser::Tree object that contains the 
                   data in the <query/> of the <iq/>.

  GetXML() - returns the XML string that represents the <iq/>. This 
             is used by the Send() function in Client.pm to send
             this object as a Jabber IQ.

  GetTree() - returns an array that contains the <iq/> tag in XML::Parser 
              Tree format.

=head2 Creation functions

  SetIQ(to=>string|JID,    - set multiple fields in the <iq/> at one
        from=>string|JID,    time.  This is a cumulative and over
        type=>string,        writing action.  If you set the "to"
        errortype=>string,   attribute twice, the second setting is
        error=>string)       what is used.  If you set the status, and
                             then set the priority then both will be in
                             the <iq/> tag.  For valid settings read the
                             specific Set functions below.

  SetTo(string) - sets the to attribute.  Must be a valid Jabber Identifier 
                  or the server will return an error message.
                  (ie.  jabber:bob@jabber.org, etc...)

  SetType(string) - sets the type attribute.  Valid settings are:

                    get     request information
                    set     set information

  SetErrorType(string) - sets the error type of the <iq/>.
 
  SetError(string) - sets the error string of the <iq/>.
 
  NewQuery(string) - creates a new Net::Jabber::Query object with the 
                     namespace in the string.  In order for this function 
                     to work with a custom namespace, you must define and 
                     register that namespace with the IQ module.  For more 
                     information please read the documentation for 
                     Net::Jabber::Query.  NOTE: Jabber does not support
                     custom IQs at the time of this writing.  This was just
                     including in case they do at some point.

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

  if ("@_" ne ("")) {
    my @temp = @_;
    $self->{IQ} = \@temp;
    my @queryTree = $self->GetQueryTree();
    $self->SetQuery(@queryTree);
  } else {
    $self->{IQ} = [ "iq" , [{}]];
  }

  return $self;
}


##############################################################################
#
# GetTag - returns the Jabber tag of this object
#
##############################################################################
sub GetTag {
  my $self = shift;
  return "iq";
}


##############################################################################
#
# GetTo - returns the Jabber Identifier of the person you are sending the
#         <iq/> to.
#
##############################################################################
sub GetTo {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"","to");
}


##############################################################################
#
# GetFrom - returns the Jabber Identifier of the person who sent the 
#           <iq/>
#
##############################################################################
sub GetFrom {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"","from");
}


##############################################################################
#
# GetID - returns the id of the <iq/>
#
##############################################################################
sub GetID {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"","id");
}


##############################################################################
#
# GetType - returns the type of the <iq/>
#
##############################################################################
sub GetType {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"","type");
}


##############################################################################
#
# GetError - returns the text associated with the error in the <iq/>
#
##############################################################################
sub GetError {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"error");
}


##############################################################################
#
# GetErrorType - returns the type of the error in the <iq/>
#
##############################################################################
sub GetErrorType {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"error","type");
}


##############################################################################
#
# GetErrorCode - returns the code of the error in the <iq/>
#
##############################################################################
sub GetErrorCode {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"error","code");
}


##############################################################################
#
# GetQuery - returns a Net::Jabber::Query object that contains the <query/>
#
##############################################################################
sub GetQuery {
  my $self = shift;
  return $self->{QUERY};
}


##############################################################################
#
# GetQueryTree - returns an XML::Parser::Tree object of the <query/> tag
#
##############################################################################
sub GetQueryTree {
  my $self = shift;
  $self->MergeQuery();
  return &Net::Jabber::GetXMLData("tree",$self->{IQ},"query");
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  $self->MergeQuery();
  return &Net::Jabber::BuildXML(@{$self->{IQ}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;
  $self->MergeQuery();
  return @{$self->{IQ}};
}


##############################################################################
#
# SetIQ - takes a hash of all of the things you can set on an <iq/> and sets
#         each one.
#
##############################################################################
sub SetIQ {
  my $self = shift;
  my %iq;
  while($#_ >= 0) { $iq{ lc pop(@_) } = pop(@_); }

  $self->SetID($iq{id}) if exists($iq{id});
  $self->SetTo($iq{to}) if exists($iq{to});
  $self->SetFrom($iq{from}) if exists($iq{from});
  $self->SetType($iq{type}) if exists($iq{type});
  $self->SetErrorCode($iq{errorcode}) if exists($iq{errorcode});
  $self->SetErrorType($iq{errortype}) if exists($iq{errortype});
  $self->SetError($iq{error}) if exists($iq{error});
}


##############################################################################
#
# SetID - sets the id attribute in the <iq/>
#
##############################################################################
sub SetID {
  my $self = shift;
  my ($id) = @_;
  &Net::Jabber::SetXMLData("single",$self->{IQ},"","",{id=>$id});
}


##############################################################################
#
# SetTo - sets the to attribute in the <iq/>
#
##############################################################################
sub SetTo {
  my $self = shift;
  my ($to) = @_;
  if (ref($to) eq "Net::Jabber::JID") {
    $to = $to->GetJID();
  }
  &Net::Jabber::SetXMLData("single",$self->{IQ},"","",{to=>$to});
}


##############################################################################
#
# SetFrom - sets the from attribute in the <iq/>
#
##############################################################################
sub SetFrom {
  my $self = shift;
  my ($from) = @_;
  if (ref($from) eq "Net::Jabber::JID") {
    $from = $from->GetJID();
  }
  &Net::Jabber::SetXMLData("single",$self->{IQ},"","",{from=>$from});
}


##############################################################################
#
# SetType - sets the type attribute in the <iq/>
#
##############################################################################
sub SetType {
  my $self = shift;
  my ($type) = @_;
  &Net::Jabber::SetXMLData("single",$self->{IQ},"","",{type=>$type});
}


##############################################################################
#
# SetErrorCode - sets the code attribute in the error tag of the <iq/>
#
##############################################################################
sub SetErrorCode {
  my $self = shift;
  my ($code) = @_;
  &Net::Jabber::SetXMLData("single",$self->{IQ},"error",,{code=>$code});
}


##############################################################################
#
# SetErrorType - sets the type attribute in the error tag of the <iq/>
#
##############################################################################
sub SetErrorType {
  my $self = shift;
  my ($type) = @_;
  &Net::Jabber::SetXMLData("single",$self->{IQ},"error",,{type=>$type});
}


##############################################################################
#
# SetError - sets the error of the <iq/>
#
##############################################################################
sub SetError {
  my $self = shift;
  my ($error) = @_;
  &Net::Jabber::SetXMLData("single",$self->{IQ},"error",$error,{});
}


##############################################################################
#
# NewQuery - calls SetQuery to create a new Net::Jabber::Query object, sets 
#            the xmlns and returns a pointer to the new object.
#
##############################################################################
sub NewQuery {
  my $self = shift;
  my ($xmlns) = @_;
  my $query = $self->SetQuery();
  $query->SetXMLNS($xmlns) if $xmlns ne "";
  return $query;
}


##############################################################################
#
# SetQuery - creates a new Net::Jabber::Query object, sets the internal
#            pointer to it, and returns a pointer to the new object.  This 
#            is a private helper function. 
#
##############################################################################
sub SetQuery {
  my $self = shift;
  my (@queryTree) = @_;
  my $query = new Net::Jabber::Query(@queryTree);
  $self->{QUERY} = $query;
  return $query;
}
  

##############################################################################
#
# MergeQuery - rebuilds the <query/>in memory and merges it into the current
#              IQ tree. This is a private helper function.  It should be used
#              any time you need access the full <iq/> so that the <query/> 
#              tag is included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeQuery {
  my $self = shift;

  my $replaced = 0;

  return if !(exists($self->{QUERY}));

  my $query = $self->{QUERY};
  my @queryTree = $query->GetTree();

  my $i;
  foreach $i (1..$#{$self->{IQ}->[1]}) {
    if ($self->{IQ}->[1]->[$i] eq "query") {
      $replaced = 1;
      $self->{IQ}->[1]->[($i+1)] = $queryTree[1];
    }
  }

  if ($replaced == 0) {
    $self->{IQ}->[1]->[($#{$self->{IQ}->[1]}+1)] = "query";
    $self->{IQ}->[1]->[($#{$self->{IQ}->[1]}+1)] = $queryTree[1];
  }
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for debugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug IQ: $self\n";
  $self->MergeQuery();
  &Net::Jabber::printData("debug: \$self->{IQ}->",$self->{IQ});
}

1;
