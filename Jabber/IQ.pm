package Net::Jabber::IQ;

=head1 NAME

Net::Jabber::IQ - Jabber Info/Query Library

=head1 SYNOPSIS

  Net::Jabber::IQ is a companion to the Net::Jabber module. It
  provides the user a simple interface to set and retrieve all 
  parts of a Jabber IQ Query.

=head1 DESCRIPTION

  Net::Jabber::IQ differs from the other Net::Jabber::* modules in that
  the XMLNS of the query is split out into more submodules under
  IQ.  For specifics on each module please view the documentation
  for each Net::Jabber::IQ::* module.  The available modules are:

    Net::Jabber::IQ::Auth      - Simple Client Authentication
    Net::Jabber::IQ::Info      - Generic Info and Profile query
    Net::Jabber::IQ::Register  - Registration requests
    Net::Jabber::IQ::Resource  - User Resource Management
    Net::Jabber::IQ::Roster    - Buddy List management

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
    $from      = $IQ->GetFrom();
    $id        = $IQ->GetID();
    $type      = $IQ->GetType();
    $xmlns     = $IQ->GetXMLNS();
    $error     = $IQ->GetError();
    $errorType = $IQ->GetErrorType();

    $queryObj  = $IQ->GetQuery();
    $tree      = $IQ->GetQueryTree();

    $str       = $IQ->GetXML();
    @iq        = $IQ->GetTree();

=head2 Creation functions

    $IQ->SetIQ(tYpE=>"get",
	       tO=>"bob@jabber.org",
	       query=>"info");

    $IQ->SetTo("bob@jabber.org");
    $IQ->SetType("set");

    $IQ->SetIQ(-to=>"bob\@jabber.org",
               -errortype=>"denied",
               -error=>"Permission Denied");
    $IQ->SetErrorType("denied");
    $IQ->SetError("Permission Denied");

    $IQObject = $IQ->NewQuery("auth");

=head1 METHODS

=head2 Retrieval functions

  GetTo() - returns a string with the Jabber Identifier of the 
            person who is going to receive the <iq/>.  <iq/>s sent
            to the server does not require a to.

  GetFrom() - returns a string with the Jabber Identifier of the 
              person who sent the <iq/>.

  GetType() - returns a string with the type <iq/> this is.

  GetID() - returns an integer with the id of the <iq/>.

  GetXMLNS() - returns a string with the namespace of the query that
               the <iq/> contains.

  GetError() - returns a string with the text description of the error.

  GetErrorType() - returns a string with the type of error.

  GetQuery() - returns a Net::Jabber::IQ::xxxxxx object that contains
               the data in the query.  To learn how to use this object
               please read the documentation for each 
               Net::Jabber::IQ::xxxxxx module.  These are listed at the
               top of this document.

  GetQueryTree() - returns an XML::Parser tree that contains the data
                   in the query.

  GetXML() - returns the XML string that represents the <iq/>. This 
             is used by the Send() function in Client.pm to send
             this object as a Jabber IQ.

  GetTree() - returns an array that contains the <iq/> tag in XML::Parser 
              Tree format.

=head2 Creation functions

  SetIQ(to=>string,        - set multiple fields in the <iq/> at one
        type=>string,        time.  This is a cumulative and over
        query=>string,       writing action.  If you set the "to"
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
 
  NewQuery(string) - returns a Net::Jabber::IQ::xxxxxx object that contains
                     the data in the query.  The kind of object that is
                     created is based on the string that you pass to 
                     NewQuery.  Valid query types are:

                     auth        Authentication
                     info        General Information
                     register    Registration information
                     resource    User Resource
                     roster      Buddy Lists

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

use Net::Jabber::IQ::Auth;
($Net::Jabber::IQ::Auth::VERSION < $VERSION) &&
  die("Net::Jabber::IQ::Auth $VERSION required--this is only version $Net::Jabber::IQ::Auth::VERSION");

use Net::Jabber::IQ::Info;
($Net::Jabber::IQ::Info::VERSION < $VERSION) &&
  die("Net::Jabber::IQ::Info $VERSION required--this is only version $Net::Jabber::IQ::Info::VERSION");

use Net::Jabber::IQ::Register;
($Net::Jabber::IQ::Register::VERSION < $VERSION) &&
  die("Net::Jabber::IQ::Register $VERSION required--this is only version $Net::Jabber::IQ::Register::VERSION");

use Net::Jabber::IQ::Resource;
($Net::Jabber::IQ::Resource::VERSION < $VERSION) &&
  die("Net::Jabber::IQ::Resource $VERSION required--this is only version $Net::Jabber::IQ::Resource::VERSION");

use Net::Jabber::IQ::Roster;
($Net::Jabber::IQ::Roster::VERSION < $VERSION) &&
  die("Net::Jabber::IQ::Roster $VERSION required--this is only version $Net::Jabber::IQ::Roster::VERSION");

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  $self->{XMLNS}->{'auth'} = "jabber:iq:auth";
  $self->{XMLNS}->{'info'} = "jabber:iq:info";
  $self->{XMLNS}->{'register'} = "jabber:iq:register";
  $self->{XMLNS}->{'resource'} = "jabber:iq:resource";
  $self->{XMLNS}->{'roster'} = "jabber:iq:roster";
  
  $self->{CONSTRUCTORS}->{'jabber:iq:auth'} = "Net::Jabber::IQ::Auth";
  $self->{CONSTRUCTORS}->{'jabber:iq:info'} = "Net::Jabber::IQ::Info";
  $self->{CONSTRUCTORS}->{'jabber:iq:register'} = "Net::Jabber::IQ::Register";
  $self->{CONSTRUCTORS}->{'jabber:iq:resource'} = "Net::Jabber::IQ::Resource";
  $self->{CONSTRUCTORS}->{'jabber:iq:roster'} = "Net::Jabber::IQ::Roster";

  if (@_ != ("")) {
    my @temp = @_;
    $self->{IQ} = \@temp;
    $self->{QUERY} = $self->BuildQuery($self->GetQueryTree());
  } else {
    $self->{IQ} = [ "iq" , [{}]];
    $self->{QUERY} = "";
  }

  return $self;
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
# GetXMLS - returns the namespace of the query in the <iq/>
#
##############################################################################
sub GetXMLNS {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"query","xmlns");  
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
# GetQuery - returns a Net::Jabber::IQ::xxxxxx object that represents the
#            <query/> in the <iq/>
#
##############################################################################
sub GetQuery {
  my $self = shift;

  $self->MergeQuery();
  return $self->{QUERY};
}


##############################################################################
#
# GetQueryTree - returns an XML::Parser tree that represents the <query/> in 
#                the <iq/>
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
  $self->SetType($iq{type}) if exists($iq{type});
  $self->NewQuery($iq{query}) if exists($iq{query});
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
  &Net::Jabber::SetXMLData("single",$self->{IQ},"","",{to=>$to});
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
# SetErrorType - sets the type attribute in the error tag of the <message/>
#
##############################################################################
sub SetErrorType {
  my $self = shift;
  my ($type) = @_;
  &Net::Jabber::SetXMLData("single",$self->{IQ},"error",,{type=>$type});
}


##############################################################################
#
# SetError - sets the error of the <message/>
#
##############################################################################
sub SetError {
  my $self = shift;
  my ($error) = @_;
  &Net::Jabber::SetXMLData("single",$self->{IQ},"error",$error,{});
}


##############################################################################
#
# NewQuery - returns a Net::Jabber::IQ::xxxxxx object based on the value
#            of the string passed to it.  You can take that object and set
#            values for the <query/> using the Set functions of each type.
#
##############################################################################
sub NewQuery {
  my $self = shift;
  my ($type) = @_;
  
  $self->SetType("set") if ($self->GetType() eq "");
  &Net::Jabber::SetXMLData("single",$self->{IQ},"query","",{xmlns=>$self->{XMLNS}->{$type}});

  $self->{QUERY} = $self->BuildQuery($self->GetQueryTree());

  return $self->{QUERY};
}

##############################################################################
#
# BuildQuery - returns the new Net::Jabber::IQ::xxxxxx object based on the
#              <query/> that is passed to it.  This is a private helper
#              function.
#
##############################################################################
sub BuildQuery {
  my $self = shift;
  my (@tree) = @_;

  my $xmlns = &Net::Jabber::GetXMLData("value",\@tree,"","xmlns");

  my $obj;
  eval("\$obj = new ".$self->{CONSTRUCTORS}->{$xmlns}."(\@tree);");

  return $obj;
}


##############################################################################
#
# MergeQuery - takes the <query/> in the Net::Jabber::IQ::xxxxxx object and
#              pulls the data out and merges it into the <iq/>.  This is a
#              private helper function.  It should be used any time you need
#              access the full <iq/> so that the <query/> is included.
#              (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeQuery {
  my $self = shift;

  return if (!$self->{QUERY});
  $self->{IQ}->[1]->[2] = ($self->{QUERY}->GetTree())[1];
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
