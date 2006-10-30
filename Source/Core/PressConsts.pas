(*
  PressObjects, Consts unit
  Copyright (C) 2006 Laserpress Ltda.

  http://www.pressobjects.org

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
*)

unit PressConsts;

interface

{$I Press.inc}

const
  SPressMaxItemCount = 100;
  SPressBrackets = '()';
  SPressAttributePrefix = '_';
  SPressAttributeSeparator = '.';
  SPressIdentifierSeparator = '_';
  SPressDataSeparator = ':';
  SPressFieldDelimiter = ';';
  SPressLineBreak = #10;
  SPressTrueString = 'True';
  SPressFalseString = 'False';
  SPressNilString = 'nil';
  SPressIdString = 'Id';
  SPressIdentifierString = 'Identifier';
  SPressIntegerString = 'Integer';
  SPressLiteralString = 'Literal';
  SPressQueryItemsString = 'QueryItems';
  SPressEofString = 'final de arquivo';

resourcestring
  SAmbiguousConcreteClass = 'Classe concreta amb�gua (%s e %s) para o objeto %s';
  SAttributeAccessError = 'N�o � poss�vel acessar o atributo %s(''%s'') como %s';
  SAttributeConversionError = 'Erro ao converter valor para o atributo %s(''%s''):' + #10 + '%s';
  SAttributeNotFound = 'O atributo %s(''%s'') n�o foi encontrado';
  SClassNotFound = 'Classe %s n�o encontrada';
  SComponentIsNotAControl = 'O componente %s(''%s'') n�o � um controle';
  SComponentNotFound = 'O componente %s(''%s'') n�o foi encontrado';
  SDialogClassIsAssigned = 'Classe do objeto de di�logo j� est� associado';
  SDisplayNameMissing = 'Falta DisplayName para o controle %s(''%s'')';
  SEnumItemNotFound = 'Enumeration ''%s'' n�o encontrado';
  SEnumMetadataNotFound = 'Enumeration metadata %s n�o encontrado';
  SInstanceNotFound = 'Instance not found: %s(%s)';
  SInvalidAttributeClass = 'O atributo %s(''%s'') requer objetos da classe %s';
  SInvalidAttributeType = 'Tipo inv�lido para o atributo %s (%s)';
  SInvalidAttributeValue = 'Valor ''%s'' inv�lido para %s(''%s'')';
  SItemCountOverflow = '<%d itens>';
  SMetadataNotFound = 'Metadata da classe %s n�o foi encontrada';
  SMetadataParseError = 'Erro ao interpretar metadata: "(%d,%d) %s"' + SPressLineBreak + '"%s"';
  SNonRelatedClasses = 'Classes %s e %s n�o s�o relacionadas';
  SNoLoggedUser = 'N�o existe usu�rio logado';
  SNoReference = 'N�o existe refer�ncia';
  SNoRegisteredReport = 'Nenhum relat�rio foi registrado';
  SPersistentClassNotFound = 'Classe persistente %s n�o encontrada';
  SSingletonClassNotFound = 'Classe Singleton %s n�o encontrada';
  SStringOverflow = 'String overflow: %s(%s)';
  STokenExpected = '''%s'' esperado, mas ''%s'' foi encontrado';
  SUnassignedAttributeType = 'Tipo de atributo n�o associado para %s(''%s'')';
  SUnassignedCandidateClasses = 'Classes candidata n�o est�o associadas';
  SUnassignedTargetClass = 'Classe alvo n�o est� associada';
  SUnassignedMainForm = 'Formul�rio principal n�o est� associado';
  SUnassignedMainPresenter = 'Presenter principal n�o est� associado';
  SUnassignedModel = 'Model n�o est� associado';
  SUnassignedPersistenceConnector = 'Conector de persist�ncia n�o foi associado';
  SUnassignedServiceType = 'Servi�o %s n�o foi associado ou registrado';
  SUnassignedSubject = 'Subject n�o foi associado';
  SUnexpectedEof = 'Fim de arquivo inesperado';
  SUnexpectedMVPClassParam = 'Classe MVP %s inicializada com par�metros inesperados';
  SUnsupportedAttribute = 'O atributo %s(''%s'') n�o � suportado';
  SUnsupportedAttributeType = 'O tipo de atributo %s n�o � suportado';
  SUnsupportedComponent = 'O componente %s n�o � suportado';
  SUnsupportedControl = 'O controle %s(''%s'') n�o � suportado';
  SUnsupportedDisplayName = 'DisplayName n�o � suportado para o atributo %s(''%s.%s'')';
  SUnsupportedFeature = 'Feature %s n�o � suportada';
  SUnsupportedModel = 'Model %s n�o � suportado por %s';
  SUnsupportedObject = 'Nenhuma classe %s suporta objetos %s';

  SConnectionManagerCaption = 'Conector';

  SPressTodayCommand = 'Hoje';
  SPressLoadPictureCommand = 'Adicionar figura';
  SPressRemovePictureCommand = 'Remover figura';
  SPressIncludeObjectCommand = 'Cadastrar novo item';
  SPressAddItemCommand = 'Adicionar item';
  SPressSelectItemCommand = 'Selecionar itens';
  SPressEditItemCommand = 'Alterar item';
  SPressRemoveItemCommand = 'Remover item';
  SPressSaveFormCommand = 'Salvar';
  SPressCancelFormCommand = 'Cancelar';
  SPressCloseFormCommand = 'Fechar';
  SPressExecuteQueryCommand = 'Executar';
  SPressAssignSelectionQueryCommand = 'Selecionar';
  SPressReportErrorString = ' ##Erro## ';

  SPressCancelChangesDialog = 'Cancelar altera��es?';
  SPressConfirmRemoveOneItemDialog = 'Um item selecionado. Confirma remo��o?';
  SPressConfirmRemoveItemsDialog = '%d itens selecionados. Confirma remo��o?';
  SPressSaveChangesDialog = 'Gravar altera��es?';

implementation

end.
