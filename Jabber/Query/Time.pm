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

package Net::Jabber::Query::Time;

=head1 NAME

Net::Jabber::Query::Time - Jabber IQ Time Module

=head1 SYNOPSIS

  Net::Jabber::Query::Time is a companion to the Net::Jabber::Query module.
  It provides the user a simple interface to set and retrieve all parts
  of a Jabber Time query.

=head1 DESCRIPTION

  To initialize the Query with a Jabber <iq/> and then access the time
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iqCB {
      my $iq = new Net::Jabber::IQ(@_);
      my $time = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new Query time to send to the server:

    use Net::Jabber;

    $client = new Net::Jabber::Client();
    ...

    $iq = new Net::Jabber::IQ();
    $time = $iq->NewQuery("jabber:iq:time");
    ...

    $client->Send($iq);

  Using $time you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $utc      = $time->GetUTC();
    $timezone = $time->GetTZ();
    $display  = $time->GetDisplay();

=head2 Creation functions

    $time->SetTime(utc=>'20000314T09:50:00',
                   tz=>'EST',
                   display=>'2000/03/14 09:50 AM');

    $time->SetUTC('20000419T13:05:34');
    $time->SetTZ('CST');
    $time->SetDisplay('2000/04/19 01:50 PM');

=head2 Test functions

    $test = $time->DefinedUTC();
    $test = $time->DefinedTZ();
    $test = $time->DefinedDisplay();

=head1 METHODS

=head2 Retrieval functions

  GetUTC() - returns a string with the universal time constant time in 
             the <query/>.

  GetTZ() - returns a string with the timezone in the <query/>.

  GetDisplay() - returns a string with the displayin the <query/>.

=head2 Creation functions

  SetTime(utc=>string,     - set multiple fields in the <iq/> at one
          tz=>string,        time.  This is a cumulative and over
          display=>string)   writing action.  If you set the "utc" 
                             twice, the second setting is what is
                             used.  If you set the tz, and then
                             set the display then both will be in the
                             <query/> tag.  For valid settings read 
                             the specific Set functions below.

  SetUTC(string) - sets the universal time constant time for the 
                   <query/>.  The format for the UTC is:
 
                     yyyymmddThh:nn:ss

                     yyyy - year
                     mm   - month
                     dd   - day
                     hh   - hour
                     nn   - minute
                     ss   - second

  SetTZ(string) - sets the timezone of the local client in the <query/>.


  SetDisplay(string) - sets the string to display as the local time in
                       UTC format in the remote client.

=head2 Test functions

  DefinedUTC() - returns 1 if <utc/> exists in the query, 0 otherwise.

  DefinedTZ() - returns 1 if <tz/> exists in the query, 0 otherwise.

  DefinedDisplay() - returns 1 if <display/> exists in the query,
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

$VERSION = "1.0019";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;
  
  if (eval "require Time::Timezone") {
    $self->{TIMEZONE} = 1;
    Time::Timezone->import(qw(tz_local_offset tz_name));
  } else {
    $self->{TIMEZONE} = 0;
  }

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
  my $self = shift;
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = "QUERY";

  return &Net::Jabber::Get($parent,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($parent,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($parent,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  &Net::Jabber::MissingFunction($parent,$AUTOLOAD);
}

$FUNCTIONS{get}->{UTC}     = ["value","utc",""];
$FUNCTIONS{get}->{TZ}      = ["value","tz",""];
$FUNCTIONS{get}->{Display} = ["value","display",""];

$FUNCTIONS{defined}->{UTC}     = ["existence","utc",""];
$FUNCTIONS{defined}->{TZ}      = ["existence","tz",""];
$FUNCTIONS{defined}->{Display} = ["existence","display",""];


##############################################################################
#
# SetTime - takes a hash of all of the things you can set on an time <query/>
#           and sets each one.
#
##############################################################################
sub SetTime {
  shift;
  my $self = shift;
  my %time;
  while($#_ >= 0) { $time{ lc pop(@_) } = pop(@_); }

  $self->{TIME} = time if ($self->{TIME} eq "");

  $self->SetUTC($time{utc});
  $self->SetTZ($time{tz});
  $self->SetDisplay($time{display});
}


##############################################################################
#
# SetUTC - sets the utc of your local client.
#
##############################################################################
sub SetUTC {
  shift;
  my $self = shift;
  my ($utc) = @_;

  $self->{TIME} = time if ($self->{TIME} eq "");

  if ($utc eq "") {
    my ($sec,$min,$hour,$mday,$mon,$year) = gmtime($self->{TIME});
    $utc = sprintf("%d%02d%02dT%02d:%02d:%02d",($year + 1900),($mon+1),$mday,$hour,$min,$sec);
  }

  &Net::Jabber::SetXMLData("single",$self->{QUERY},"utc",$utc,{});
}


##############################################################################
#
# SetTZ - sets the timezone of your local client.
#
##############################################################################
sub SetTZ {
  my $realSelf = shift;
  my $self = shift;
  my ($tz) = @_;

  $self->{TIME} = time if ($self->{TIME} eq "");

  if ($tz eq "") {
    if ($realSelf->{TIMEZONE} == 1) {
      $tz = uc(&tz_name(&tz_local_offset()));
    } else {
      return;
    }
  }

  &Net::Jabber::SetXMLData("single",$self->{QUERY},"tz",$tz,{});
}


##############################################################################
#
# SetDisplay - sets the display time that the remote client should use.
#
##############################################################################
sub SetDisplay {
  shift;
  my $self = shift;
  my ($display) = @_;

  $self->{TIME} = time if ($self->{TIME} eq "");

  if ($display eq "") {
    $display = &Net::Jabber::GetTimeStamp("local",$self->{TIME});
  }

  &Net::Jabber::SetXMLData("single",$self->{QUERY},"display",$display,{});
}

1;
