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

package Net::Jabber::Message;

=head1 NAME

Net::Jabber::Message - Jabber Message Module

=head1 SYNOPSIS

  Net::Jabber::Message is a companion to the Net::Jabber module.
  It provides the user a simple interface to set and retrieve all
  parts of a Jabber Message.

=head1 DESCRIPTION

  To initialize the Message with a Jabber <message/> you must pass it
  the XML::Stream hash.  For example:

    my $message = new Net::Jabber::Message(%hash);

  There has been a change from the old way of handling the callbacks.
  You no longer have to do the above yourself, a Net::Jabber::Message
  object is passed to the callback function for the message.  Also,
  the first argument to the callback functions is the session ID from
  XML::Streams.  There are some cases where you might want this
  information, like if you created a Client that connects to two servers
  at once, or for writing a mini server.

    use Net::Jabber qw(Client);

    sub message {
      my ($sid,$Mess) = @_;
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new message to send to the server:

    use Net::Jabber qw(Client);

    $Mess = new Net::Jabber::Message();

  Now you can call the creation functions below to populate the tag
  before sending it.

  For more information about the array format being passed to the
  CallBack please read the Net::Jabber::Client documentation.

=head1 METHODS

=head2 Retrieval functions

  GetTo()      - returns the value in the to='' attribute for the
  GetTo("jid")   <message/>.  If you specify "jid" as an argument
                 then a Net::Jabber::JID object is returned and
                 you can easily parse the parts of the JID.

                 $to    = $Mess->GetTo();
                 $toJID = $Mess->GetTo("jid");

  GetFrom()      - returns the value in the from='' attribute for the
  GetFrom("jid")   <message/>.  If you specify "jid" as an argument
                   then a Net::Jabber::JID object is returned and
                   you can easily parse the parts of the JID.

                   $from    = $Mess->GetFrom();
                   $fromJID = $Mess->GetFrom("jid");

  GetType() - returns the type='' attribute of the <message/>.  Each
              message is one of four types:

                normal        regular message (default if type is blank)
                chat          one on one chat
                groupchat     multi-person chat
                headline      headline
                error         error message

              $type = $Mess->GetType();

  GetSubject() - returns the data in the <subject/> tag.

                 $subject = $Mess->GetSubject();

  GetBody() - returns the data in the <body/> tag.

              $body = $Mess->GetBody();

  GetThread() - returns the data in the <thread/> tag.

                $thread = $Mess->GetThread();

  GetError() - returns a string with the data of the <error/> tag.

               $error = $Mess->GetError();

  GetErrorCode() - returns a string with the code='' attribute of the
                   <error/> tag.

                   $errCode = $Mess->GetErrorCode();

  GetTimeStamp() - returns a string that represents the time this
                   message object was created (and probably received)
                   for sending to the client.  If there is a
                   jabber:x:delay tag then that time is used to show
                   when the message was sent.

                   $date = $Mess->GetTimeStamp();


=head2 Creation functions

  SetMessage(to=>string|JID,    - set multiple fields in the <message/>
             from=>string|JID,    at one time.  This is a cumulative
             type=>string,        and over writing action.  If you set
             subject=>string,     the "to" attribute twice, the second
             body=>string,        setting is what is used.  If you set
             thread=>string,      the subject, and then set the body
             errorcode=>string,   then both will be in the <message/>
             error=>string)       tag.  For valid settings read the
                                  specific Set functions below.

                            $Mess->SetMessage(TO=>"bob\@jabber.org",
					      Subject=>"Lunch",
					      BoDy=>"Let's do lunch!");
                            $Mess->SetMessage(to=>"bob\@jabber.org",
					      from=>"jabber.org",
					      errorcode=>404,
					      error=>"Not found");

  SetTo(string) - sets the to='' attribute.  You can either pass
  SetTo(JID)      a string or a JID object.  They must be valid Jabber
                  Identifiers or the server will return an error message.
                  (ie.  bob@jabber.org/Work)

                  $Mess->SetTo("test\@jabber.org");

  SetFrom(string) - sets the from='' attribute.  You can either pass
  SetFrom(JID)      a string or a JID object.  They must be valid Jabber
                    Identifiers or the server will return an error
                    message. (ie.  jabber:bob@jabber.org/Work)
                    This field is not required if you are writing a
                    Client since the server will put the JID of your
                    connection in there to prevent spamming.

                    $Mess->SetFrom("me\@jabber.org");

  SetType(string) - sets the type attribute.  Valid settings are:

                      normal         regular message (default if blank)
                      chat           one one one chat style message
                      groupchat      multi-person chatroom message
                      headline       news headline, stock ticker, etc...
                      error          error message

                    $Mess->SetType("groupchat");

  SetSubject(string) - sets the subject of the <message/>.

                       $Mess->SetSubject("This is a test");

  SetBody(string) - sets the body of the <message/>.

                    $Mess->SetBody("To be or not to be...");

  SetThread(string) - sets the thread of the <message/>.  You should
                      copy this out of the message being replied to so
                      that the thread is maintained.

                      $Mess->SetThread("AE912B3");

  SetErrorCode(string) - sets the error code of the <message/>.

                         $Mess->SetErrorCode(403);

  SetError(string) - sets the error string of the <message/>.

                     $Mess->SetError("Permission Denied");

  Reply(hash,                   - creates a new Message object and
        template=>string,         populates the to/from based on
        replytransport=>string)   the value of template, and the
                                  subject by putting "re: " in front
                                  if the type is normal.  The following
                                  templates are available:

                                  normal: (default)
                                       just sets the to/from

                                  transport-filter:
                                       the transport will send the
                                       reply to the address from the
                                       to.  ie( bob%j.org@transport.j.org
                                       would send to bob@j.org)

                                  transport-filter-reply:
                                       the transport will send the
                                       reply to the address from the
                                       to.  ie( bob%j.org@transport.j.org
                                       would send to bob@j.org) and
                                       set the from to be
                                       sender@replytransport.  That
                                       way a two way filter can occur.

                                  If you specify a hash the same as with
                                  SetMessage then those values will 
                                  override the Reply values.

                                  $Reply = $Mess->Reply();
                                  $Reply = $Mess->Reply(type=>"chat");
                                  $Reply = $Mess->Reply(template=>...);

=head2 Test functions

  DefinedTo() - returns 1 if the to attribute is defined in the
                <message/>, 0 otherwise.

                $test = $Mess->DefinedTo();

  DefinedFrom() - returns 1 if the from attribute is defined in the
                  <message/>, 0 otherwise.

                  $test = $Mess->DefinedFrom();

  DefinedType() - returns 1 if the type attribute is defined in the
                  <message/>, 0 otherwise.

                  $test = $Mess->DefinedType();

  DefinedSubject() - returns 1 if <subject/> is defined in the
                     <message/>, 0 otherwise.

                     $test = $Mess->DefinedSubject();

  DefinedBody() - returns 1 if <body/> is defined in the <message/>,
                  0 otherwise.

                  $test = $Mess->DefinedBody();

  DefinedThread() - returns 1 if <thread/> is defined in the <message/>,
                    0 otherwise.

                    $test = $Mess->DefinedThread();

  DefinedErrorCode() - returns 1 if <error/> is defined in the
                       <message/>, 0 otherwise.

                       $test = $Mess->DefinedErrorCode();

  DefinedError() - returns 1 if the code attribute is defined in the
                   <error/>, 0 otherwise.

                   $test = $Mess->DefinedError();

=head1 AUTHOR

By Ryan Eatmon in May of 2001 for http://jabber.org

=head1 COPYRIGHT

This module is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.0023";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };

  $self->{VERSION} = $VERSION;
  $self->{TIMESTAMP} = &Net::Jabber::GetTimeStamp("local");

  bless($self, $proto);

  $self->{DEBUGHEADER} = "Message";

  $self->{DATA} = {};
  $self->{CHILDREN} = {};

  $self->{TAG} = "message";

  if ("@_" ne ("")) {
    if (ref($_[0]) eq "Net::Jabber::Message") {
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


$FUNCTIONS{Body}->{Get}        = "body";
$FUNCTIONS{Body}->{Set}        = ["scalar","body"];
$FUNCTIONS{Body}->{Defined}    = "body";
$FUNCTIONS{Body}->{Hash}       = "child-data";

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

$FUNCTIONS{Subject}->{Get}        = "subject";
$FUNCTIONS{Subject}->{Set}        = ["scalar","subject"];
$FUNCTIONS{Subject}->{Defined}    = "subject";
$FUNCTIONS{Subject}->{Hash}       = "child-data";

$FUNCTIONS{Thread}->{Get}        = "thread";
$FUNCTIONS{Thread}->{Set}        = ["scalar","thread"];
$FUNCTIONS{Thread}->{Defined}    = "thread";
$FUNCTIONS{Thread}->{Hash}       = "child-data";

$FUNCTIONS{To}->{Get}        = "to";
$FUNCTIONS{To}->{Set}        = ["jid","to"];
$FUNCTIONS{To}->{Defined}    = "to";
$FUNCTIONS{To}->{Hash}       = "att";

$FUNCTIONS{Type}->{Get}        = "type";
$FUNCTIONS{Type}->{Set}        = ["scalar","type"];
$FUNCTIONS{Type}->{Defined}    = "type";
$FUNCTIONS{Type}->{Hash}       = "att";

$FUNCTIONS{X}->{Get}     = "__netjabber__:children:x";
$FUNCTIONS{X}->{Defined} = "__netjabber__:children:x";

$FUNCTIONS{Message}->{Get} = "__netjabber__:master";
$FUNCTIONS{Message}->{Set} = ["master"];


##############################################################################
#
# GetTimeStamp - returns a string with the time stamp of when this object
#                was created.
#
##############################################################################
sub GetTimeStamp {
  my $self = shift;

  if ($self->DefinedX("jabber:x:delay")) {
    my @xTags = $self->GetX("jabber:x:delay");
    my $xTag = $xTags[0];
    $self->{TIMESTAMP} = &Net::Jabber::GetTimeStamp("utcdelaylocal",$xTag->GetStamp());
  }

  return $self->{TIMESTAMP};
}


##############################################################################
#
# Reply - returns a Net::Jabber::Message object with the proper fields
#         already populated for you.
#
##############################################################################
sub Reply {
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  $args{template} = "normal" unless exists($args{template});
  my $template = delete($args{template});
  my $replytransport = delete($args{replytransport});

  my $reply = new Net::Jabber::Message();

  if (($self->GetType() eq "") || ($self->GetType() eq "normal")) {
    my $subject = $self->GetSubject();
    $subject =~ s/re\:\s+//i;
    $reply->SetSubject("re: $subject");
  }
  $reply->SetThread($self->GetThread()) if ($self->GetThread() ne "");
  $reply->SetID($self->GetID()) if ($self->GetID() ne "");
  $reply->SetType($self->GetType()) if ($self->GetType() ne "");

  if ($template eq "transport-filter") {
    my $toJID = $self->GetTo("jid");
    my $fromJID = $self->GetFrom("jid");

    my $filterToJID = new Net::Jabber::JID($toJID->GetUserID());

    $reply->SetMessage(to=>$filterToJID,
		       from=>$fromJID
		      );
  } else {
    if ($template eq "transport-filter-reply") {
      my $toJID = $self->GetTo("jid");
      my $fromJID = $self->GetFrom("jid");

      my $filterToJID = new Net::Jabber::JID($toJID->GetUserID());
      my $filterFromJID = new Net::Jabber::JID($fromJID->GetUserID()."\%".$fromJID->GetServer()."\@".$replytransport);

      $reply->SetMessage(to=>$filterToJID,
			 from=>$filterFromJID
			);
    } else {
      $reply->SetMessage(to=>$self->GetFrom(),
			 from=>$self->GetTo());
    }
  }

  $reply->SetMessage(%args);

  return $reply;
}


1;
