package Net::Jabber::Query::Agents;

=head1 NAME

Net::Jabber::Query::Agents - Jabber Query Agents Module

=head1 SYNOPSIS

  Net::Jabber::Query::Agents is a companion to the Net::Jabber::Query 
  module. It provides the user a simple interface to set and retrieve all 
  parts of a Jabber Query Agents.

=head1 DESCRIPTION

  To initialize the Agents with a Jabber <iq/> you must pass it the 
  XML::Parser Tree array from the module trying to access the <iq/>.  
  In the callback function:

    use Net::Jabber;

    sub iqCB {
      my $iq = new Net::Jabber::IQ(@_);
      my $agents = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new Agents request to send to the server:

    use Net::Jabber;

    $client = new Net::Jabber::Client();

    $iq = new Net::Jabber::IQ();
    $agents = $iq->NewQuery("jabber:iq:agents");

    $client->Send($iq);

  Or you can call the creation functions below before sending.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    @agents = $agents->GetAgents();

=head2 Creation functions


    $agent = $agents->NewAgent(jid=>"icq.jabber.org",
			       name=>"ICQ Transport",
			       description=>"This is the ICQ Transport",
			       transport=>"ICQ#",
			       service=>"icq",
			       register=>"",
			       search=>"");
    $agent = $agents->NewAgent();

    $agent->SetXXXXX()

=head1 METHODS

=head2 Retrieval functions

  GetAgents() - returns an array of jabber:iq:agent objects.  For
                more info on this object see the docs for 
                Net::Jabber::Query::Agent.

=head2 Creation functions

  NewAgent(jid=>string,         - creates a new jabber:iq:agent object
           name=>string,          and sets multiple fields in the <iq/> 
           description=>string,   at one time.  This is a cumulative and
           transport=>string,     over writing action.  If you set the
           service=>string,       "jid" attribute twice, the second
           register=>string,      setting is what is used.  If you set
           search=>string)        the name, and then set the search
                                  then both will be in the <iq/> tag. 
                                  For valid settings read the specific
                                  Set functions in Net::Jabber::Query::Agent.
                                  This function returns a new JID object
                                  that you can call the SetXXX functions
                                  on directly if you want.

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
# GetAgents - returns an array of Net::Jabber::Query::Agent objects containing
#             the list of available Transport/Agents on the server.
#
##############################################################################
sub GetAgents {
  shift;
  my $self = shift;

  my @agentArrays = &Net::Jabber::GetXMLData("tree array",$self->{QUERY},"agent","");
  my @agents;
  my $agent;
  foreach $agent (@agentArrays) {
    push(@agents,new Net::Jabber::Query::Agent(@{$agent}));
  }

  return @agents;
}


##############################################################################
#
# NewAgent - returns a Net::Jabber::Query::Agent object.
#
##############################################################################
sub NewAgent {
  shift;
  my $self = shift;

  my $agent = new Net::Jabber::Query::Agent(["item",[{}]]);
  $agent->SetAgent(@_);
  return $agent;
}


1;
