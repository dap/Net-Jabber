package Net::Jabber::Query::Agent;

=head1 NAME

Net::Jabber::Query::Agent - Jabber Query Agent Module

=head1 SYNOPSIS

  Net::Jabber::Query::Agent is a companion to the Net::Jabber::Query 
  module. It provides the user a simple interface to set and retrieve all 
  parts of a Jabber Query Agent.

=head1 DESCRIPTION

  To initialize the Agent with a Jabber <iq/> you must pass it the 
  XML::Parser Tree array from the module trying to access the <iq/>.  
  In the callback function:

    use Net::Jabber;

    sub iqCB {
      my $iq = new Net::Jabber::IQ(@_);
      my $agent = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new Agent to send to the server:

    use Net::Jabber;

    $iq = new Net::Jabber::IQ();
    $agent = $iq->NewQuery("jabber:iq:agent");

  Now you can call the creation functions below.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $jid         = $agent->GetJID();
    $name        = $agent->GetName();
    $description = $agent->GetDescription();
    $transport   = $agent->GetTransport();
    $service     = $agent->GetService();
    $register    = $agent->GetRegister();
    $search      = $agent->GetSearch();
    $groupchat   = $agent->GetGroupChat();
    $agents      = $agent->GetAgents();

=head2 Creation functions

    $agent->SetAgent(jid=>"users.jabber.org",
		     name=>"Jabber User Directory",
	             description=>"You may register and create a public 
                                   searchable profile, and search for 
                                   other registered Jabber users.",
		     service=>"jud",
		     register=>"",
		     search=>"");

    $agent->SetJID("icq.jabber.org");
    $agent->SetName("ICQ Transport");
    $agent->SetDescription("This is the ICQ Transport");
    $agent->SetTransport("ICQ#");
    $agent->SetService("icq");
    $agent->SetRegister();
    $agent->SetSearch();
    $agent->SetGroupChat();
    $agent->SetAgents();

=head2 Test functions
 
    $test = $agent->DefinedJID();
    $test = $agent->DefinedName();
    $test = $agent->DefinedDescription();
    $test = $agent->DefinedTransport();
    $test = $agent->DefinedService();
    $test = $agent->DefinedRegister();
    $test = $agent->DefinedSearch();
    $test = $agent->DefinedGroupChat();
    $test = $agent->DefinedAgents();

=head1 METHODS

=head2 Retrieval functions

  GetJID() - returns a string with the JID of the agent to send 
             messages to.

  GetName() - returns a string with the name of the agent.

  GetDescription() - returns a string with the description of 
                     the agent.

  GetTransport() - returns a string with the transport of the agent.

  GetService() - returns a string with the service name of the agent.

  GetRegister() - returns a 1 if the agent supports registering, 
                  0 if not.

  GetSearch() - returns a 1 if the agent supports searching, 0 if not.

  GetGroupChat() - returns a 1 if the agent supports groupchat, 0 if not.

  GetAgents() - returns a 1 if the agent supports sub-agents, 0 if not.


=head2 Creation functions

  SetAgent(jid=>string,         - set multiple fields in the <iq/> at one
           name=>string,          time.  This is a cumulative and over
           description=>string,   writing action.  If you set the "jid"
           transport=>string,     attribute twice, the second setting is
           service=>string,       what is used.  If you set the name, and
           register=>string,      then set the search then both will be in
           search=>string,        the <iq/> tag.  For valid settings read the
           groupchat=>string)     specific Set functions below.
           agents=>string)

  SetJID(string) - sets the jid="..." of the agent.

  SetName(string) - sets the <name/> of the agent.

  SetDescription(string) - sets the <description/> of the agent.

  SetTransport(string) - sets the <transport/> of the agent.

  SetService(string) - sets the <service/> of the agent.

  SetRegister() - if the function is called then a <search/> is
                  is put in the <query/> to signify searching is
                  available.

  SetSearch() - if the function is called then a <search/> is
                is put in the <query/> to signify searching is
                available.

  SetGroupChat() - if the function is called then a <groupchat/> is
                   is put in the <query/> to signify groupchat is
                   available.

  SetAgents() - if the function is called then a <agents/> is
                is put in the <query/> to signify sub-agents are
                available.

=head2 Test functions
 
  DefinedJID() - returns 1 if jid is in the parrent tag, 
                 0 otherwise.

  DefinedName() - returns 1 if <name/> is in the parent tag, 
                  0 otherwise.

  DefinedDescription() - returns 1 if <description/> is in the parent tag,
                         0 otherwise.

  DefinedTransport() - returns 1 if <transport/> is in the parent tag, 
                       0 otherwise.

  DefinedService() - returns 1 if <service/> is in the parent tag, 
                     0 otherwise.

  DefinedRegister() - returns 1 if <register/> is in the parent tag, 
                      0 otherwise.

  DefinedSearch() - returns 1 if <search/> is in the parent tag, 
                    0 otherwise.

  DefinedGroupChat() - returns 1 if <groupchat/> is in the parent tag, 
                       0 otherwise.

  DefinedAgents() - returns 1 if <agents/> is in the parent tag, 
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

$VERSION = "1.0017";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };

  if ("@_" ne "") {
    my @temp = @_;
    $self->{AGENT} = \@temp;
  }
  
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
  my $self = (exists($parent->{AGENT}) ? $parent : shift );
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = (exists($parent->{AGENT}) ? "AGENT" : "QUERY");
  
  return &Net::Jabber::MissingFunction($parent,$AUTOLOAD)
    if (($treeName eq "QUERY") && ($value eq "JID"));
  return &Net::Jabber::BuildXML(@{$parent->{AGENT}}) if ($AUTOLOAD eq "GetXML");
  return @{$parent->{AGENT}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($parent,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($parent,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($parent,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($parent,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($parent,$AUTOLOAD);
}


$FUNCTIONS{get}->{JID}         = ["value","","jid"];
$FUNCTIONS{get}->{Name}        = ["value","name",""];
$FUNCTIONS{get}->{Description} = ["value","description",""];
$FUNCTIONS{get}->{Transport}   = ["value","transport",""];
$FUNCTIONS{get}->{Service}     = ["value","service",""];
$FUNCTIONS{get}->{Register}    = ["value","register",""];
$FUNCTIONS{get}->{Search}      = ["value","search",""];
$FUNCTIONS{get}->{GroupChat}   = ["value","groupchat",""];
$FUNCTIONS{get}->{Agents}      = ["value","agents",""];

$FUNCTIONS{set}->{JID}         = ["single","","","jid","*"];
$FUNCTIONS{set}->{Name}        = ["single","name","*","",""];
$FUNCTIONS{set}->{Description} = ["single","description","*","",""];
$FUNCTIONS{set}->{Transport}   = ["single","transport","*","",""];
$FUNCTIONS{set}->{Service}     = ["single","service","*","",""];
$FUNCTIONS{set}->{Register}    = ["single","register","*","",""];
$FUNCTIONS{set}->{Search}      = ["single","search","*","",""];
$FUNCTIONS{set}->{GroupChat}   = ["single","groupchat","*","",""];
$FUNCTIONS{set}->{Agents}      = ["single","agents","*","",""];

$FUNCTIONS{defined}->{JID}         = ["existence","","jid"];
$FUNCTIONS{defined}->{Name}        = ["existence","name",""];
$FUNCTIONS{defined}->{Description} = ["existence","description",""];
$FUNCTIONS{defined}->{Transport}   = ["existence","transport",""];
$FUNCTIONS{defined}->{Service}     = ["existence","service",""];
$FUNCTIONS{defined}->{Register}    = ["existence","register",""];
$FUNCTIONS{defined}->{Search}      = ["existence","search",""];
$FUNCTIONS{defined}->{GroupChat}   = ["existence","groupchat",""];
$FUNCTIONS{defined}->{Agents}      = ["existence","agents",""];


##############################################################################
#
# SetAgent - takes a hash of all of the things you can set on a 
#            jabber:iq:agent and sets each one.
#
##############################################################################
sub SetAgent {
  my $self = shift;
  $self = shift if !exists($self->{AGENT});
  my %agent;
  while($#_ >= 0) { $agent{ lc pop(@_) } = pop(@_); }

  $self->SetJID($agent{jid}) if exists($agent{jid});
  $self->SetName($agent{name}) if exists($agent{name});
  $self->SetDescription($agent{description}) if exists($agent{description});
  $self->SetTransport($agent{transport}) if exists($agent{transport});
  $self->SetService($agent{service}) if exists($agent{service});
  $self->SetRegister() if exists($agent{register});
  $self->SetSearch() if exists($agent{search});
  $self->SetGroupChat() if exists($agent{groupchat});
  $self->SetAgents() if exists($agent{agents});
}


1;
