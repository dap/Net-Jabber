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

package Net::Jabber::Query::AutoUpdate::Release;

=head1 NAME

Net::Jabber::Query::AutoUpdate::Release - Jabber IQ AutoUpdate Release Module

=head1 SYNOPSIS

  Net::Jabber::Query::AutoUpdate::Release is a companion to the 
  Net::Jabber::Query::AutoUpdate module.  It provides the user a simple 
  interface to set and retrieve all parts of a Jabber AutoUpdate Release.

=head1 DESCRIPTION

  To initialize the Item with a Jabber <iq/> and then access the auth
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      my $autoupdate = $iq->GetQuery();
      my $release = $roster->GetRelease();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available below.

  To create a new IQ Roster Item to send to the server:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $iq = new Net::Jabber::IQ();
    $autoupdate = $iq->NewQuery("jabber:iq:autoupdate");
    $release = $roster->AddRelease(type=>"beta");
    ...

    $client->Send($iq);

  Using $release you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $version     = $release->GetVersion();
    $description = $release->GetDesc();
    $url         = $release->GetURL();
    $priority    = $release->GetPriority();

    @release     = $release->GetTree();
    $str          = $release->GetXML();

=head2 Creation functions

    $release->SetRelease(version=>"1.3.2",
		         desc=>"Bob's Client for Jabber",
		         url=>"http://www.bobssite.com/client.1.3.2.tar.gz",
		         priority=>"optional");
    $release->SetVersion('5.6');
    $release->SetDesc('A description of the client');
    $release->SetURL('http://somesite/path/client.tar.gz');
    $release->SetPriority("mandatory");

=head2 Test functions

    $test = $release->DefinedVersion();
    $test = $release->DefinedDesc();
    $test = $release->DefinedURL();
    $test = $release->DefinedPriority();

=head1 METHODS

=head2 Retrieval functions

  GetVersion() - returns a string with the version number of this release.

  GetDesc() - returns a string with the description of this release.

  GetURL() - returns a string with the URL for downloading this release.

  GetPriority() - returns a string with the priority of this release.

                    optional  - The user can get it if they want to
                    mandatory - The user must get this version

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetRelease(version=>string,  - set multiple fields in the release
             desc=>string,       at one time.  This is a cumulative
             url=>string,        and overwriting action.  If you
             priority=>string,   set the "url" twice, the second
                                 setting is what is used.  If you set
                                 the desc, and then set the
                                 priority then both will be in the
                                 release tag.  For valid settings
                                 read the specific Set functions below.

  SetVersion(string) - sets the version number of this release.

  SetDesc(string) - sets the description of this release.

  SetURL(string) - sets the url for downloading this release.

  SetPriotity(string) - sets the priority of this release.  If "" or not
                        "optional" or "mandatory" then this defaults to
                        "optional".

=head2 Test functions

  DefinedVersion() - returns 1 if <version/> is defined in the query, 0
                     otherwise.

  DefinedDesc() -  returns 1 if <desc/> is defined in the query, 0
                   otherwise.

  DefinedURL() -  returns 1 if <url/> is defined in the query, 0
                  otherwise.

  DefinedPriority() -  returns 1 if priority is defined in the query, 0
                       otherwise.


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

$VERSION = "1.0019";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  if ("@_" ne ("")) {
    if ($#_ == 1) {
      my @temp = @_;
      $self->{RELEASE} = \@temp;
    } else {
      $self->{RELEASE} = [ "@_", [ {} ]];
    }
  } else {
    print "ERROR: You must specify a type for Net::Jabber::Query::AutoUpdate::Release.\n";
    print "       (release,dev,beta)\n";
    exit(0);
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
  my $treeName = "RELEASE";

  return &Net::Jabber::BuildXML(@{$self->{RELEASE}}) if ($AUTOLOAD eq "GetXML");
  return @{$self->{RELEASE}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{Version}  = ["value","version",""];
$FUNCTIONS{get}->{Desc}     = ["value","desc",""];
$FUNCTIONS{get}->{URL}      = ["value","url",""];
$FUNCTIONS{get}->{Priority} = ["value","","priority"];

$FUNCTIONS{set}->{Version}  = ["single","version","*","",""];
$FUNCTIONS{set}->{Desc}     = ["single","desc","*","",""];
$FUNCTIONS{set}->{URL}      = ["single","url","*","",""];
$FUNCTIONS{set}->{Priority} = ["single","","","priority","*"];

$FUNCTIONS{defined}->{Version}  = ["existence","version",""];
$FUNCTIONS{defined}->{Desc}     = ["existence","desc",""];
$FUNCTIONS{defined}->{URL}      = ["existence","url",""];
$FUNCTIONS{defined}->{Priority} = ["existence","","priority"];


##############################################################################
#
# SetRelease - takes a hash of all of the things you can set on a release 
#              <query/> and sets each one.
#
##############################################################################
sub SetRelease {
  my $self = shift;
  my %release;
  while($#_ >= 0) { $release{ lc pop(@_) } = pop(@_); }
  
  $self->SetVersion($release{version}) if exists($release{version});
  $self->SetDesc($release{desc}) if exists($release{desc});
  $self->SetURL($release{url}) if exists($release{url});
  $self->SetPriority($release{priority}) if exists($release{priority});
}


1;
