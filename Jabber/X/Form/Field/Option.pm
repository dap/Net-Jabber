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

package Net::Jabber::X::Form::Field::Option;

=head1 NAME

Net::Jabber::X::Form::Field::Option - Jabber X Form Field Option Module

=head1 SYNOPSIS

  Net::Jabber::X::Form::Field::Option is a companion to the 
  Net::Jabber::X::Form::Field module.  It provides the user a simple 
  interface to set and retrieve all parts of a Jabber Form Field
  Option.

=head1 DESCRIPTION

  To initialize the Option with a Jabber <x/> and then access the </x>
  you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the object
  type foo:

    use Net::Jabber;

    sub foo {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:form");

      my $xTag;
      foreach $xTag (@xTags) {
        my @fields = $xTag->GetFields();
	my $field;
	foreach $field (@fields) {
	  if ($field->GetType() eq "option") {
	    foreach my $option ($field->GetOptions()) {
	      $option->GetXXXX();
	    }
	  }
	  .
	  .
	  .
	}
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available below.

  To create a new X Form Field Option to send to another user:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $foo = new Net::Jabber::Foo();
    $form = $foo->NewX("jabber:x:form");
    $field = $form->AddField(tpye=>"option");
    $option = $field->AddOption();
    ...

    $client->Send($foo);

  Using $field you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $label  = $option->GetLabel();
    $value  = $option->GetValue();

    @option = $option->GetTree();
    $str    = $option->GetXML();

=head2 Creation functions

    $option->SetOption(label=>"Male",
		       value=>"m");

    $option->SetLabel('Yes');
    $option->SetValue('1');

=head2 Test functions

    $test = $option->DefinedLabel();
    $test = $option->DefinedValue();

=head1 METHODS

=head2 Retrieval functions

  GetLabel() - returns a string with the label that the option should have
               in the GUI.

  GetValuel() - returns a string with the value that the option should have
                when selected.

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetOption(label=>string, - set multiple options in the <option/>
            value=>string)   at one time.  This is a cumulative
                             and overwriting action.  If you
                             set the "label" twice, the second
                             setting is what is used.  If you set
                             the label, and then set the
                             value then both will be in the
                             <option/> tag.  For valid settings
                             read the specific Set functions below.

  SetLabel(string) - sets the label to show in the GUI for this option.

  SetValue(string) - sets the value to set the field to when this option
                     is selected in the GUI.

=head2 Test functions

  DefinedLabel() - returns 1 if the label attribute is set in the <field/>,
                   0 otherwise.

  DefinedValue() - returns 1 if the value attribute is set in the <field/>,
                   0 otherwise.

=head1 AUTHOR

By Ryan Eatmon in February of 2001 for http://jabber.org..

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

  bless($self, $proto);

  if ("@_" ne ("")) {
    my @temp = @_;
    $self->{OPTION} = \@temp;
  } else {
    $self->{OPTION} = [ "option" , [{}]];
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
  my $treeName = "OPTION";
  
  return &Net::Jabber::BuildXML(@{$self->{$treeName}}) if ($AUTOLOAD eq "GetXML");
  return @{$self->{$treeName}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{Value} = ["value","","value"];
$FUNCTIONS{get}->{Label} = ["value","","label"];

$FUNCTIONS{set}->{Value} = ["single","","","value","*"];
$FUNCTIONS{set}->{Label} = ["single","","","label","*"];

$FUNCTIONS{defined}->{Value} = ["existence","","value"];
$FUNCTIONS{defined}->{Label} = ["existence","","label"];


##############################################################################
#
# SetOption - takes a hash of all of the things you can set on an option <x/>
#           and sets each one.
#
##############################################################################
sub SetOption {
  my $self = shift;
  my %option;
  while($#_ >= 0) { $option{ lc pop(@_) } = pop(@_); }
  
  $self->SetValue($option{value}) if exists($option{value});
  $self->SetLabel($option{label}) if exists($option{label});
}


1;
