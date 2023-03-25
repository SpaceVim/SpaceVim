" Vim syntax file
" Language:     PlantUML
" License:      VIM LICENSE
if exists('b:current_syntax')
  finish
endif

if v:version < 600
  syntax clear
endif

let s:cpo_orig=&cpoptions
set cpoptions&vim

let b:current_syntax = 'plantuml'

syntax sync minlines=100

syntax match plantumlPreProc /\%(^@start\|^@end\)\%(board\|bpm\|creole\|cute\|def\|ditaa\|dot\|flow\|gantt\|git\|jcckit\|json\|latex\|math\|mindmap\|nwdiag\|project\|salt\|tree\|uml\|wbs\|wire\|yaml\)/
syntax match plantumlPreProc /!\%(assert\|define\|definelong\|dump_memory\|else\|enddefinelong\|endfunction\|endif\|endprocedure\|endsub\|exit\|function\|if\|ifdef\|ifndef\|import\|include\|local\|log\|pragma\|procedure\|return\|startsub\|theme\|undef\|unquoted\)\s*.*/ contains=plantumlDir
syntax region plantumlDir start=/\s\+/ms=s+1 end=/$/ contained

" type
" From 'java - jar plantuml.jar - language' results {{{
syntax keyword plantumlTypeKeyword abstract actor agent annotation archimate artifact boundary card cloud
syntax keyword plantumlTypeKeyword collections component control database diamond entity enum file folder frame
syntax keyword plantumlTypeKeyword hexagon label node object package participant person queue rectangle stack state
syntax keyword plantumlTypeKeyword storage usecase
" class and interface are defined as plantumlClassKeyword
syntax keyword plantumlClassKeyword class interface
"}}}
" Not in 'java - jar plantuml.jar - language' results
syntax keyword plantumlTypeKeyword concise robust

" keyword
" From 'java - jar plantuml.jar - language' results {{{
" Since "syntax keyword" can handle only words, "top to bottom direction", "left to right direction" are excluded.
syntax keyword plantumlKeyword across activate again allow_mixing allowmixing also alt as autonumber bold
syntax keyword plantumlKeyword bottom box break caption center circle color create critical dashed deactivate
syntax keyword plantumlKeyword description destroy detach dotted down else elseif empty end endif endwhile
syntax keyword plantumlKeyword false footbox footer fork group header hide hnote if is italic kill left legend
syntax keyword plantumlKeyword link loop mainframe map members namespace newpage normal note of on opt order
syntax keyword plantumlKeyword over package page par partition plain ref repeat return right rnote rotate show
syntax keyword plantumlKeyword skin skinparam split sprite start stereotype stop style then title top true up
syntax keyword plantumlKeyword while

"}}}
" Not in 'java - jar plantuml.jar - language' results
syntax keyword plantumlKeyword endlegend sprite then
" gantt
syntax keyword plantumlTypeKeyword monday tuesday wednesday thursday friday saturday sunday today
syntax keyword plantumlTypeKeyword project Project labels Labels last first column
syntax keyword plantumlKeyword starts ends start end closed after colored lasts happens in at are to the and
syntax keyword plantumlKeyword printscale ganttscale projectscale daily weekly monthly quarterly yearly zoom
syntax keyword plantumlKeyword day days week weeks today then complete displays same row pauses

syntax keyword plantumlCommentTODO XXX TODO FIXME NOTE contained
syntax match plantumlColor /#[0-9A-Fa-f]\{6\}\>/
syntax case ignore
syntax keyword plantumlColor APPLICATION AliceBlue AntiqueWhite Aqua Aquamarine Azure BUSINESS Beige Bisque
syntax keyword plantumlColor Black BlanchedAlmond Blue BlueViolet Brown BurlyWood CadetBlue Chartreuse
syntax keyword plantumlColor Chocolate Coral CornflowerBlue Cornsilk Crimson Cyan DarkBlue DarkCyan
syntax keyword plantumlColor DarkGoldenRod DarkGray DarkGreen DarkGrey DarkKhaki DarkMagenta DarkOliveGreen
syntax keyword plantumlColor DarkOrchid DarkRed DarkSalmon DarkSeaGreen DarkSlateBlue DarkSlateGray
syntax keyword plantumlColor DarkSlateGrey DarkTurquoise DarkViolet Darkorange DeepPink DeepSkyBlue DimGray
syntax keyword plantumlColor DimGrey DodgerBlue FireBrick FloralWhite ForestGreen Fuchsia Gainsboro
syntax keyword plantumlColor GhostWhite Gold GoldenRod Gray Green GreenYellow Grey HoneyDew HotPink
syntax keyword plantumlColor IMPLEMENTATION IndianRed Indigo Ivory Khaki Lavender LavenderBlush LawnGreen
syntax keyword plantumlColor LemonChiffon LightBlue LightCoral LightCyan LightGoldenRodYellow LightGray
syntax keyword plantumlColor LightGreen LightGrey LightPink LightSalmon LightSeaGreen LightSkyBlue
syntax keyword plantumlColor LightSlateGray LightSlateGrey LightSteelBlue LightYellow Lime LimeGreen Linen
syntax keyword plantumlColor MOTIVATION Magenta Maroon MediumAquaMarine MediumBlue MediumOrchid MediumPurple
syntax keyword plantumlColor MediumSeaGreen MediumSlateBlue MediumSpringGreen MediumTurquoise MediumVioletRed
syntax keyword plantumlColor MidnightBlue MintCream MistyRose Moccasin NavajoWhite Navy OldLace Olive
syntax keyword plantumlColor OliveDrab Orange OrangeRed Orchid PHYSICAL PaleGoldenRod PaleGreen PaleTurquoise
syntax keyword plantumlColor PaleVioletRed PapayaWhip PeachPuff Peru Pink Plum PowderBlue Purple Red
syntax keyword plantumlColor RosyBrown RoyalBlue STRATEGY SaddleBrown Salmon SandyBrown SeaGreen SeaShell
syntax keyword plantumlColor Sienna Silver SkyBlue SlateBlue SlateGray SlateGrey Snow SpringGreen SteelBlue
syntax keyword plantumlColor TECHNOLOGY Tan Teal Thistle Tomato Turquoise Violet Wheat White WhiteSmoke
syntax keyword plantumlColor Yellow YellowGreen
syntax case match

" Arrows
syntax match plantumlArrow /.\@=\([.-]\)\1\+\ze\s*\%(\w\|(\)/

syntax match plantumlClassRelationLR /\([-.]\)\1*\%(\w\{,5\}\1\+\)\?\%(|>\|>\|*\|o\|x\|#\|{\|+\|\^\)/ contains=plantumlArrowDirectedLine
syntax match plantumlClassRelationRL /\%(<|\|<\|*\|o\|x\|#\|}\|+\|\^\)\([-.]\)\1*\%(\w\{,5\}\1\+\)\?/ contains=plantumlArrowDirectedLine

syntax match plantumlArrowLR /\[\?\([-.]\)\1*\%(\w\{,5}\1\+\)\?\%(\[[^\]]\+\]\)\?\1*\(>\|\\\|\/\)\2\?[ox]\?\]\?\%(\[[^\]]*\]\)\?/ contains=plantumlText,plantumlArrowDirectedLine
syntax match plantumlArrowRL /\[\?[ox]\?\(<\|\\\|\/\)\1\?\([-.]\)\2*\%(\w\{,5}\2\+\)\?\]\?\%(\[[^\]]*\]\)\?/ contains=plantumlText,plantumlArrowDirectedLine
syntax match plantumlArrowBoth /[ox]\?\(<\|\\\|\/\)\1\?\([-.]\)\2*\%(\w\{,5}\2\+\)\?\(>\|\\\|\/\)\3\?[ox]\?/ contains=plantumlArrowDirectedLine
syntax region plantumlText oneline start=/\[/ms=s+1 end=/\]/me=s-1 contained

syntax match plantumlArrowDirectedLine /\([-.]\)\%(l\%[eft]\|r\%[ight]\|up\?\|d\%[own]\)\1/ contained

" Note and legend
syntax region plantumlNoteMultiLine start=/\%(^\s*[rh]\?\%(note\|legend\)\)\@<=\s\%([^:"]\+$\)\@=/ end=/^\%(\s*\zeend\s*[rh]\?\%(note\|legend\)$\)\|endlegend\@=/ contains=plantumlSpecialString,plantumlNoteMultiLineStart,plantumlTag
syntax match plantumlNoteMultiLineStart /\%(^\s*[rh]\?\%(note\|legend\)\)\@<=\s\%([^:]\+$\)/ contained contains=plantumlKeyword,plantumlColor,plantumlString,plantumlTag

" Class
syntax region plantumlClass
      \ start=/\%(\%(class\|interface\|object\)\s[^{]\+\)\@<=\zs{/
      \ end=/^\s*}/
      \ contains=plantumlClassArrows,
      \          plantumlClassKeyword,
      \          @plantumlClassOp,
      \          plantumlClassSeparator,
      \          plantumlComment

syntax match plantumlClassPublic      /^\s*+\s*\w\+/ contained
syntax match plantumlClassPrivate     /^\s*-\s*\w\+/ contained
syntax match plantumlClassProtected   /^\s*#\s*\w\+/ contained
syntax match plantumlClassPackPrivate /^\s*\~\s*\w\+/ contained
syntax match plantumlClassSeparator   /__\%(.\+__\)\?\|==\%(.\+==\)\?\|--\%(.\+--\)\?\|\.\.\%(.\+\.\.\)\?/ contained

syntax cluster plantumlClassOp contains=plantumlClassPublic,
      \                                 plantumlClassPrivate,
      \                                 plantumlClassProtected,
      \                                 plantumlClassPackPrivate

" Strings
syntax match plantumlSpecialString /\\n/ contained
syntax region plantumlString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=plantumlSpecialString
syntax region plantumlString start=/'/ skip=/\\\\\|\\'/ end=/'/ oneline contains=plantumlSpecialString
syntax match plantumlComment /^\s*'.*$/ contains=plantumlCommentTODO
syntax region plantumlMultilineComment start=/\/'/ end=/'\// contains=plantumlCommentTODO

syntax match plantumlTag /<\/\?[bi]>/
syntax region plantumlTag start=/<\/\?\%(back\|color\|del\|font\|img\|s\|size\|strike\|u\|w\)/ end=/>/

" Labels with a colon
syntax match plantumlColonLine /\S\@<=\s*\zs : .\+$/ contains=plantumlSpecialString

" Stereotypes
syntax match plantumlStereotype /<<[^-.]\+>>/ contains=plantumlSpecialString

" Activity diagram
syntax match plantumlActivityThing /([^)]*)/
syntax match plantumlActivitySynch /===[^=]\+===/
syntax match plantumlActivityLabel /\%(^\%(#\S\+\)\?\)\@<=:\_[^;|<>/\]}]\+[;|<>/\]}]$/ contains=plantumlSpecialString

" Sequence diagram
syntax match plantumlSequenceDivider /^\s*==[^=]\+==\s*$/
syntax match plantumlSequenceSpace /^\s*|||\+\s*$/
syntax match plantumlSequenceSpace /^\s*||\d\+||\+\s*$/
syntax match plantumlSequenceDelay /^\s*\.\{3}$/
syntax region plantumlText oneline matchgroup=plantumlSequenceDelay start=/^\s*\.\{3}/ end=/\.\{3}$/

" Usecase diagram
syntax match plantumlUsecaseActor /^\s*:.\{-1,}:/ contains=plantumlSpecialString


" Mindmap diagram
let s:mindmapHilightLinks = [
      \ 'WarningMsg', 'Directory', 'Special', 'MoreMsg', 'Statement', 'Title',
      \ 'Question', 'LineNr', 'ModeMsg', 'Title', 'MoreMsg', 'SignColumn',
      \ 'Function', 'Todo'
      \  ]

let s:i = 1
let s:contained = []
let s:mindmap_color = '\(\[#[^\]]\+\]\)\?'
let s:mindmap_removing_box = '_\?'
let s:mindmap_options = join([s:mindmap_color, s:mindmap_removing_box], '')
while s:i < len(s:mindmapHilightLinks)
  execute 'syntax match plantumlMindmap' . s:i . ' /^\([-+*]\)\1\{' . (s:i - 1) . '}' . s:mindmap_options . '\(:\|\s\+\)/ contained'
  execute 'syntax match plantumlMindmap' . s:i . ' /^\s\{' . (s:i - 1) . '}\*' . s:mindmap_options . '\(:\|\s\+\)/ contained'
  execute 'highlight default link plantumlMindmap' . s:i . ' ' . s:mindmapHilightLinks[s:i - 1]
  call add(s:contained, 'plantumlMindmap' . s:i)
  let s:i = s:i + 1
endwhile

execute 'syntax region plantumlMindmap oneline start=/^\([-+*]\)\1*' . s:mindmap_options . '\s/ end=/$/ contains=' . join(s:contained, ',')
" Multilines
execute 'syntax region plantumlMindmap start=/^\([-+*]\)\1*' . s:mindmap_options . ':/ end=/;$/ contains=' . join(s:contained, ',')
" Markdown syntax
execute 'syntax region plantumlMindmap oneline start=/^\s*\*' . s:mindmap_options . '\s/ end=/$/ contains=' . join(s:contained, ',')

" Gantt diagram
syntax match plantumlGanttTask /\[[^\]]\{-}\]\%('s\)\?/ contains=plantumlSpecialString


" Skinparam keywords
syntax case ignore
syntax keyword plantumlSkinparamKeyword ActivityBackgroundColor ActivityBarColor ActivityBorderColor
syntax keyword plantumlSkinparamKeyword ActivityBorderThickness ActivityDiamondBackgroundColor
syntax keyword plantumlSkinparamKeyword ActivityDiamondBorderColor ActivityDiamondFontColor ActivityDiamondFontName
syntax keyword plantumlSkinparamKeyword ActivityDiamondFontSize ActivityDiamondFontStyle ActivityEndColor
syntax keyword plantumlSkinparamKeyword ActivityFontColor ActivityFontName ActivityFontSize ActivityFontStyle
syntax keyword plantumlSkinparamKeyword ActivityStartColor ActorBackgroundColor ActorBorderColor ActorFontColor
syntax keyword plantumlSkinparamKeyword ActorFontName ActorFontSize ActorFontStyle ActorStereotypeFontColor
syntax keyword plantumlSkinparamKeyword ActorStereotypeFontName ActorStereotypeFontSize ActorStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword AgentBackgroundColor AgentBorderColor AgentBorderThickness AgentFontColor
syntax keyword plantumlSkinparamKeyword AgentFontName AgentFontSize AgentFontStyle AgentStereotypeFontColor
syntax keyword plantumlSkinparamKeyword AgentStereotypeFontName AgentStereotypeFontSize AgentStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword ArchimateBackgroundColor ArchimateBorderColor ArchimateBorderThickness
syntax keyword plantumlSkinparamKeyword ArchimateFontColor ArchimateFontName ArchimateFontSize ArchimateFontStyle
syntax keyword plantumlSkinparamKeyword ArchimateStereotypeFontColor ArchimateStereotypeFontName
syntax keyword plantumlSkinparamKeyword ArchimateStereotypeFontSize ArchimateStereotypeFontStyle ArrowColor
syntax keyword plantumlSkinparamKeyword ArrowFontColor ArrowFontName ArrowFontSize ArrowFontStyle ArrowHeadColor
syntax keyword plantumlSkinparamKeyword ArrowLollipopColor ArrowMessageAlignment ArrowThickness ArtifactBackgroundColor
syntax keyword plantumlSkinparamKeyword ArtifactBorderColor ArtifactFontColor ArtifactFontName ArtifactFontSize
syntax keyword plantumlSkinparamKeyword ArtifactFontStyle ArtifactStereotypeFontColor ArtifactStereotypeFontName
syntax keyword plantumlSkinparamKeyword ArtifactStereotypeFontSize ArtifactStereotypeFontStyle BackgroundColor
syntax keyword plantumlSkinparamKeyword BiddableBackgroundColor BiddableBorderColor BoundaryBackgroundColor
syntax keyword plantumlSkinparamKeyword BoundaryBorderColor BoundaryFontColor BoundaryFontName BoundaryFontSize
syntax keyword plantumlSkinparamKeyword BoundaryFontStyle BoundaryStereotypeFontColor BoundaryStereotypeFontName
syntax keyword plantumlSkinparamKeyword BoundaryStereotypeFontSize BoundaryStereotypeFontStyle BoxPadding
syntax keyword plantumlSkinparamKeyword CaptionFontColor CaptionFontName CaptionFontSize CaptionFontStyle
syntax keyword plantumlSkinparamKeyword CardBackgroundColor CardBorderColor CardBorderThickness CardFontColor
syntax keyword plantumlSkinparamKeyword CardFontName CardFontSize CardFontStyle CardStereotypeFontColor
syntax keyword plantumlSkinparamKeyword CardStereotypeFontName CardStereotypeFontSize CardStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword CircledCharacterFontColor CircledCharacterFontName CircledCharacterFontSize
syntax keyword plantumlSkinparamKeyword CircledCharacterFontStyle CircledCharacterRadius ClassAttributeFontColor
syntax keyword plantumlSkinparamKeyword ClassAttributeFontName ClassAttributeFontSize ClassAttributeFontStyle
syntax keyword plantumlSkinparamKeyword ClassAttributeIconSize ClassBackgroundColor ClassBorderColor
syntax keyword plantumlSkinparamKeyword ClassBorderThickness ClassFontColor ClassFontName ClassFontSize ClassFontStyle
syntax keyword plantumlSkinparamKeyword ClassHeaderBackgroundColor ClassStereotypeFontColor ClassStereotypeFontName
syntax keyword plantumlSkinparamKeyword ClassStereotypeFontSize ClassStereotypeFontStyle CloudBackgroundColor
syntax keyword plantumlSkinparamKeyword CloudBorderColor CloudFontColor CloudFontName CloudFontSize CloudFontStyle
syntax keyword plantumlSkinparamKeyword CloudStereotypeFontColor CloudStereotypeFontName CloudStereotypeFontSize
syntax keyword plantumlSkinparamKeyword CloudStereotypeFontStyle CollectionsBackgroundColor CollectionsBorderColor
syntax keyword plantumlSkinparamKeyword ColorArrowSeparationSpace ComponentBackgroundColor ComponentBorderColor
syntax keyword plantumlSkinparamKeyword ComponentBorderThickness ComponentFontColor ComponentFontName ComponentFontSize
syntax keyword plantumlSkinparamKeyword ComponentFontStyle ComponentStereotypeFontColor ComponentStereotypeFontName
syntax keyword plantumlSkinparamKeyword ComponentStereotypeFontSize ComponentStereotypeFontStyle ComponentStyle
syntax keyword plantumlSkinparamKeyword ConditionEndStyle ConditionStyle ControlBackgroundColor ControlBorderColor
syntax keyword plantumlSkinparamKeyword ControlFontColor ControlFontName ControlFontSize ControlFontStyle
syntax keyword plantumlSkinparamKeyword ControlStereotypeFontColor ControlStereotypeFontName ControlStereotypeFontSize
syntax keyword plantumlSkinparamKeyword ControlStereotypeFontStyle DatabaseBackgroundColor DatabaseBorderColor
syntax keyword plantumlSkinparamKeyword DatabaseFontColor DatabaseFontName DatabaseFontSize DatabaseFontStyle
syntax keyword plantumlSkinparamKeyword DatabaseStereotypeFontColor DatabaseStereotypeFontName
syntax keyword plantumlSkinparamKeyword DatabaseStereotypeFontSize DatabaseStereotypeFontStyle DefaultFontColor
syntax keyword plantumlSkinparamKeyword DefaultFontName DefaultFontSize DefaultFontStyle DefaultMonospacedFontName
syntax keyword plantumlSkinparamKeyword DefaultTextAlignment DesignedBackgroundColor DesignedBorderColor
syntax keyword plantumlSkinparamKeyword DesignedDomainBorderThickness DesignedDomainFontColor DesignedDomainFontName
syntax keyword plantumlSkinparamKeyword DesignedDomainFontSize DesignedDomainFontStyle DesignedDomainStereotypeFontColor
syntax keyword plantumlSkinparamKeyword DesignedDomainStereotypeFontName DesignedDomainStereotypeFontSize
syntax keyword plantumlSkinparamKeyword DesignedDomainStereotypeFontStyle DiagramBorderColor DiagramBorderThickness
syntax keyword plantumlSkinparamKeyword DomainBackgroundColor DomainBorderColor DomainBorderThickness DomainFontColor
syntax keyword plantumlSkinparamKeyword DomainFontName DomainFontSize DomainFontStyle DomainStereotypeFontColor
syntax keyword plantumlSkinparamKeyword DomainStereotypeFontName DomainStereotypeFontSize DomainStereotypeFontStyle Dpi
syntax keyword plantumlSkinparamKeyword EntityBackgroundColor EntityBorderColor EntityFontColor EntityFontName
syntax keyword plantumlSkinparamKeyword EntityFontSize EntityFontStyle EntityStereotypeFontColor
syntax keyword plantumlSkinparamKeyword EntityStereotypeFontName EntityStereotypeFontSize EntityStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword EnumBackgroundColor FileBackgroundColor FileBorderColor FileFontColor
syntax keyword plantumlSkinparamKeyword FileFontName FileFontSize FileFontStyle FileStereotypeFontColor
syntax keyword plantumlSkinparamKeyword FileStereotypeFontName FileStereotypeFontSize FileStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword FixCircleLabelOverlapping FolderBackgroundColor FolderBorderColor
syntax keyword plantumlSkinparamKeyword FolderFontColor FolderFontName FolderFontSize FolderFontStyle
syntax keyword plantumlSkinparamKeyword FolderStereotypeFontColor FolderStereotypeFontName FolderStereotypeFontSize
syntax keyword plantumlSkinparamKeyword FolderStereotypeFontStyle FooterFontColor FooterFontName FooterFontSize
syntax keyword plantumlSkinparamKeyword FooterFontStyle FrameBackgroundColor FrameBorderColor FrameFontColor
syntax keyword plantumlSkinparamKeyword FrameFontName FrameFontSize FrameFontStyle FrameStereotypeFontColor
syntax keyword plantumlSkinparamKeyword FrameStereotypeFontName FrameStereotypeFontSize FrameStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword GenericDisplay Guillemet Handwritten HeaderFontColor HeaderFontName
syntax keyword plantumlSkinparamKeyword HeaderFontSize HeaderFontStyle HexagonBackgroundColor HexagonBorderColor
syntax keyword plantumlSkinparamKeyword HexagonBorderThickness HexagonFontColor HexagonFontName HexagonFontSize
syntax keyword plantumlSkinparamKeyword HexagonFontStyle HexagonStereotypeFontColor HexagonStereotypeFontName
syntax keyword plantumlSkinparamKeyword HexagonStereotypeFontSize HexagonStereotypeFontStyle HyperlinkColor
syntax keyword plantumlSkinparamKeyword HyperlinkUnderline IconIEMandatoryColor IconPackageBackgroundColor
syntax keyword plantumlSkinparamKeyword IconPackageColor IconPrivateBackgroundColor IconPrivateColor
syntax keyword plantumlSkinparamKeyword IconProtectedBackgroundColor IconProtectedColor IconPublicBackgroundColor
syntax keyword plantumlSkinparamKeyword IconPublicColor InterfaceBackgroundColor InterfaceBorderColor InterfaceFontColor
syntax keyword plantumlSkinparamKeyword InterfaceFontName InterfaceFontSize InterfaceFontStyle
syntax keyword plantumlSkinparamKeyword InterfaceStereotypeFontColor InterfaceStereotypeFontName
syntax keyword plantumlSkinparamKeyword InterfaceStereotypeFontSize InterfaceStereotypeFontStyle LabelFontColor
syntax keyword plantumlSkinparamKeyword LabelFontName LabelFontSize LabelFontStyle LabelStereotypeFontColor
syntax keyword plantumlSkinparamKeyword LabelStereotypeFontName LabelStereotypeFontSize LabelStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword LegendBackgroundColor LegendBorderColor LegendBorderThickness LegendFontColor
syntax keyword plantumlSkinparamKeyword LegendFontName LegendFontSize LegendFontStyle LexicalBackgroundColor
syntax keyword plantumlSkinparamKeyword LexicalBorderColor LifelineStrategy Linetype MachineBackgroundColor
syntax keyword plantumlSkinparamKeyword MachineBorderColor MachineBorderThickness MachineFontColor MachineFontName
syntax keyword plantumlSkinparamKeyword MachineFontSize MachineFontStyle MachineStereotypeFontColor
syntax keyword plantumlSkinparamKeyword MachineStereotypeFontName MachineStereotypeFontSize MachineStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword MaxAsciiMessageLength MaxMessageSize MinClassWidth Monochrome
syntax keyword plantumlSkinparamKeyword NodeBackgroundColor NodeBorderColor NodeFontColor NodeFontName NodeFontSize
syntax keyword plantumlSkinparamKeyword NodeFontStyle NodeStereotypeFontColor NodeStereotypeFontName
syntax keyword plantumlSkinparamKeyword NodeStereotypeFontSize NodeStereotypeFontStyle Nodesep NoteBackgroundColor
syntax keyword plantumlSkinparamKeyword NoteBorderColor NoteBorderThickness NoteFontColor NoteFontName NoteFontSize
syntax keyword plantumlSkinparamKeyword NoteFontStyle NoteShadowing NoteTextAlignment ObjectAttributeFontColor
syntax keyword plantumlSkinparamKeyword ObjectAttributeFontName ObjectAttributeFontSize ObjectAttributeFontStyle
syntax keyword plantumlSkinparamKeyword ObjectBackgroundColor ObjectBorderColor ObjectBorderThickness ObjectFontColor
syntax keyword plantumlSkinparamKeyword ObjectFontName ObjectFontSize ObjectFontStyle ObjectStereotypeFontColor
syntax keyword plantumlSkinparamKeyword ObjectStereotypeFontName ObjectStereotypeFontSize ObjectStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword PackageBackgroundColor PackageBorderColor PackageBorderThickness
syntax keyword plantumlSkinparamKeyword PackageFontColor PackageFontName PackageFontSize PackageFontStyle
syntax keyword plantumlSkinparamKeyword PackageStereotypeFontColor PackageStereotypeFontName PackageStereotypeFontSize
syntax keyword plantumlSkinparamKeyword PackageStereotypeFontStyle PackageStyle PackageTitleAlignment Padding
syntax keyword plantumlSkinparamKeyword PageBorderColor PageExternalColor PageMargin ParticipantBackgroundColor
syntax keyword plantumlSkinparamKeyword ParticipantBorderColor ParticipantFontColor ParticipantFontName
syntax keyword plantumlSkinparamKeyword ParticipantFontSize ParticipantFontStyle ParticipantPadding
syntax keyword plantumlSkinparamKeyword ParticipantStereotypeFontColor ParticipantStereotypeFontName
syntax keyword plantumlSkinparamKeyword ParticipantStereotypeFontSize ParticipantStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword PartitionBackgroundColor PartitionBorderColor PartitionBorderThickness
syntax keyword plantumlSkinparamKeyword PartitionFontColor PartitionFontName PartitionFontSize PartitionFontStyle
syntax keyword plantumlSkinparamKeyword PathHoverColor PersonBackgroundColor PersonBorderColor PersonBorderThickness
syntax keyword plantumlSkinparamKeyword PersonFontColor PersonFontName PersonFontSize PersonFontStyle
syntax keyword plantumlSkinparamKeyword PersonStereotypeFontColor PersonStereotypeFontName PersonStereotypeFontSize
syntax keyword plantumlSkinparamKeyword PersonStereotypeFontStyle QueueBackgroundColor QueueBorderColor
syntax keyword plantumlSkinparamKeyword QueueBorderThickness QueueFontColor QueueFontName QueueFontSize QueueFontStyle
syntax keyword plantumlSkinparamKeyword QueueStereotypeFontColor QueueStereotypeFontName QueueStereotypeFontSize
syntax keyword plantumlSkinparamKeyword QueueStereotypeFontStyle Ranksep RectangleBackgroundColor RectangleBorderColor
syntax keyword plantumlSkinparamKeyword RectangleBorderThickness RectangleFontColor RectangleFontName RectangleFontSize
syntax keyword plantumlSkinparamKeyword RectangleFontStyle RectangleStereotypeFontColor RectangleStereotypeFontName
syntax keyword plantumlSkinparamKeyword RectangleStereotypeFontSize RectangleStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword RequirementBackgroundColor RequirementBorderColor RequirementBorderThickness
syntax keyword plantumlSkinparamKeyword RequirementFontColor RequirementFontName RequirementFontSize
syntax keyword plantumlSkinparamKeyword RequirementFontStyle RequirementStereotypeFontColor
syntax keyword plantumlSkinparamKeyword RequirementStereotypeFontName RequirementStereotypeFontSize
syntax keyword plantumlSkinparamKeyword RequirementStereotypeFontStyle ResponseMessageBelowArrow RoundCorner
syntax keyword plantumlSkinparamKeyword SameClassWidth SequenceActorBorderThickness SequenceArrowThickness
syntax keyword plantumlSkinparamKeyword SequenceBoxBackgroundColor SequenceBoxBorderColor SequenceBoxFontColor
syntax keyword plantumlSkinparamKeyword SequenceBoxFontName SequenceBoxFontSize SequenceBoxFontStyle
syntax keyword plantumlSkinparamKeyword SequenceDelayFontColor SequenceDelayFontName SequenceDelayFontSize
syntax keyword plantumlSkinparamKeyword SequenceDelayFontStyle SequenceDividerBackgroundColor SequenceDividerBorderColor
syntax keyword plantumlSkinparamKeyword SequenceDividerBorderThickness SequenceDividerFontColor SequenceDividerFontName
syntax keyword plantumlSkinparamKeyword SequenceDividerFontSize SequenceDividerFontStyle SequenceGroupBackgroundColor
syntax keyword plantumlSkinparamKeyword SequenceGroupBodyBackgroundColor SequenceGroupBorderColor
syntax keyword plantumlSkinparamKeyword SequenceGroupBorderThickness SequenceGroupFontColor SequenceGroupFontName
syntax keyword plantumlSkinparamKeyword SequenceGroupFontSize SequenceGroupFontStyle SequenceGroupHeaderFontColor
syntax keyword plantumlSkinparamKeyword SequenceGroupHeaderFontName SequenceGroupHeaderFontSize
syntax keyword plantumlSkinparamKeyword SequenceGroupHeaderFontStyle SequenceLifeLineBackgroundColor
syntax keyword plantumlSkinparamKeyword SequenceLifeLineBorderColor SequenceLifeLineBorderThickness
syntax keyword plantumlSkinparamKeyword SequenceMessageAlignment SequenceMessageTextAlignment
syntax keyword plantumlSkinparamKeyword SequenceNewpageSeparatorColor SequenceParticipant
syntax keyword plantumlSkinparamKeyword SequenceParticipantBorderThickness SequenceReferenceAlignment
syntax keyword plantumlSkinparamKeyword SequenceReferenceBackgroundColor SequenceReferenceBorderColor
syntax keyword plantumlSkinparamKeyword SequenceReferenceBorderThickness SequenceReferenceFontColor
syntax keyword plantumlSkinparamKeyword SequenceReferenceFontName SequenceReferenceFontSize SequenceReferenceFontStyle
syntax keyword plantumlSkinparamKeyword SequenceReferenceHeaderBackgroundColor SequenceStereotypeFontColor
syntax keyword plantumlSkinparamKeyword SequenceStereotypeFontName SequenceStereotypeFontSize
syntax keyword plantumlSkinparamKeyword SequenceStereotypeFontStyle Shadowing StackBackgroundColor StackBorderColor
syntax keyword plantumlSkinparamKeyword StackFontColor StackFontName StackFontSize StackFontStyle
syntax keyword plantumlSkinparamKeyword StackStereotypeFontColor StackStereotypeFontName StackStereotypeFontSize
syntax keyword plantumlSkinparamKeyword StackStereotypeFontStyle StateAttributeFontColor StateAttributeFontName
syntax keyword plantumlSkinparamKeyword StateAttributeFontSize StateAttributeFontStyle StateBackgroundColor
syntax keyword plantumlSkinparamKeyword StateBorderColor StateEndColor StateFontColor StateFontName StateFontSize
syntax keyword plantumlSkinparamKeyword StateFontStyle StateMessageAlignment StateStartColor StereotypeABackgroundColor
syntax keyword plantumlSkinparamKeyword StereotypeABorderColor StereotypeCBackgroundColor StereotypeCBorderColor
syntax keyword plantumlSkinparamKeyword StereotypeEBackgroundColor StereotypeEBorderColor StereotypeIBackgroundColor
syntax keyword plantumlSkinparamKeyword StereotypeIBorderColor StereotypeNBackgroundColor StereotypeNBorderColor
syntax keyword plantumlSkinparamKeyword StereotypePosition StorageBackgroundColor StorageBorderColor StorageFontColor
syntax keyword plantumlSkinparamKeyword StorageFontName StorageFontSize StorageFontStyle StorageStereotypeFontColor
syntax keyword plantumlSkinparamKeyword StorageStereotypeFontName StorageStereotypeFontSize StorageStereotypeFontStyle
syntax keyword plantumlSkinparamKeyword Style SvglinkTarget SwimlaneBorderColor SwimlaneBorderThickness
syntax keyword plantumlSkinparamKeyword SwimlaneTitleBackgroundColor SwimlaneTitleFontColor SwimlaneTitleFontName
syntax keyword plantumlSkinparamKeyword SwimlaneTitleFontSize SwimlaneTitleFontStyle SwimlaneWidth
syntax keyword plantumlSkinparamKeyword SwimlaneWrapTitleWidth TabSize TimingFontColor TimingFontName TimingFontSize
syntax keyword plantumlSkinparamKeyword TimingFontStyle TitleBackgroundColor TitleBorderColor TitleBorderRoundCorner
syntax keyword plantumlSkinparamKeyword TitleBorderThickness TitleFontColor TitleFontName TitleFontSize TitleFontStyle
syntax keyword plantumlSkinparamKeyword UsecaseBackgroundColor UsecaseBorderColor UsecaseBorderThickness
syntax keyword plantumlSkinparamKeyword UsecaseFontColor UsecaseFontName UsecaseFontSize UsecaseFontStyle
syntax keyword plantumlSkinparamKeyword UsecaseStereotypeFontColor UsecaseStereotypeFontName UsecaseStereotypeFontSize
syntax keyword plantumlSkinparamKeyword UsecaseStereotypeFontStyle WrapWidth

" Not in 'java - jar plantuml.jar - language' output
syntax keyword plantumlSkinparamKeyword activityArrowColor activityArrowFontColor activityArrowFontName
syntax keyword plantumlSkinparamKeyword activityArrowFontSize activityArrowFontStyle BarColor BorderColor
syntax keyword plantumlSkinparamKeyword CharacterFontColor CharacterFontName CharacterFontSize CharacterFontStyle
syntax keyword plantumlSkinparamKeyword CharacterRadius classArrowColor classArrowFontColor classArrowFontName
syntax keyword plantumlSkinparamKeyword classArrowFontSize classArrowFontStyle Color componentArrowColor
syntax keyword plantumlSkinparamKeyword componentArrowFontColor componentArrowFontName componentArrowFontSize
syntax keyword plantumlSkinparamKeyword componentArrowFontStyle componentInterfaceBackgroundColor
syntax keyword plantumlSkinparamKeyword componentInterfaceBorderColor DividerBackgroundColor DividerFontColor
syntax keyword plantumlSkinparamKeyword DividerFontName DividerFontSize DividerFontStyle EndColor FontColor FontName
syntax keyword plantumlSkinparamKeyword FontSize FontStyle GroupBackgroundColor GroupingFontColor GroupingFontName
syntax keyword plantumlSkinparamKeyword GroupingFontSize GroupingFontStyle GroupingHeaderFontColor
syntax keyword plantumlSkinparamKeyword GroupingHeaderFontName GroupingHeaderFontSize GroupingHeaderFontStyle
syntax keyword plantumlSkinparamKeyword LifeLineBackgroundColor LifeLineBorderColor
syntax keyword plantumlSkinparamKeyword LineColor LineStyle LineThickness
syntax keyword plantumlSkinparamKeyword sequenceActorBackgroundColor sequenceActorBorderColor sequenceActorFontColor
syntax keyword plantumlSkinparamKeyword sequenceActorFontName sequenceActorFontSize sequenceActorFontStyle
syntax keyword plantumlSkinparamKeyword sequenceArrowColor sequenceArrowFontColor sequenceArrowFontName
syntax keyword plantumlSkinparamKeyword sequenceArrowFontSize sequenceArrowFontStyle sequenceGroupingFontColor
syntax keyword plantumlSkinparamKeyword sequenceGroupingFontName sequenceGroupingFontSize sequenceGroupingFontStyle
syntax keyword plantumlSkinparamKeyword sequenceGroupingHeaderFontColor sequenceGroupingHeaderFontName
syntax keyword plantumlSkinparamKeyword sequenceGroupingHeaderFontSize sequenceGroupingHeaderFontStyle
syntax keyword plantumlSkinparamKeyword sequenceParticipantBackgroundColor sequenceParticipantBorderColor
syntax keyword plantumlSkinparamKeyword sequenceParticipantFontColor sequenceParticipantFontName
syntax keyword plantumlSkinparamKeyword sequenceParticipantFontSize sequenceParticipantFontStyle StartColor
syntax keyword plantumlSkinparamKeyword stateArrowColor stateArrowFontColor stateArrowFontName stateArrowFontSize
syntax keyword plantumlSkinparamKeyword stateArrowFontStyle StereotypeFontColor StereotypeFontName StereotypeFontSize
syntax keyword plantumlSkinparamKeyword StereotypeFontStyle usecaseActorBackgroundColor usecaseActorBorderColor
syntax keyword plantumlSkinparamKeyword usecaseActorFontColor usecaseActorFontName usecaseActorFontSize
syntax keyword plantumlSkinparamKeyword usecaseActorFontStyle usecaseActorStereotypeFontColor
syntax keyword plantumlSkinparamKeyword usecaseActorStereotypeFontName usecaseActorStereotypeFontSize
syntax keyword plantumlSkinparamKeyword usecaseActorStereotypeFontStyle usecaseArrowColor usecaseArrowFontColor
syntax keyword plantumlSkinparamKeyword usecaseArrowFontName usecaseArrowFontSize usecaseArrowFontStyle
syntax case match

" Builtin Function
" https://plantuml.com/ja/preprocessing
syntax match plantumlBuiltinFunction /%\%(chr\|darken\|date\|dec2hex\|dirpath\|feature\|false\|file_exists\|filename\|function_exists\|get_variable_value\|getenv\|hex2dec\|hsl_color\|intval\|is_dark\|is_light\|lighten\|loadJSON\|lower\|newline\|not\|lighten\|reverse_color\|reverse_hsluv_color\|set_variable_value\|size\|string\|strlen\|strpos\|substr\|true\|upper\|variable_exists\|version\)/

" Highlight
highlight default link plantumlCommentTODO Todo
highlight default link plantumlKeyword Keyword
highlight default link plantumlClassKeyword Keyword
highlight default link plantumlTypeKeyword Type
highlight default link plantumlPreProc PreProc
highlight default link plantumlDir Constant
highlight default link plantumlColor Constant
highlight default link plantumlArrow Identifier
highlight default link plantumlArrowBoth Identifier
highlight default link plantumlArrowLR Identifier
highlight default link plantumlArrowRL Identifier
highlight default link plantumlArrowDirectedLine Identifier
highlight default link plantumlClassRelationLR Identifier
highlight default link plantumlClassRelationRL Identifier
highlight default link plantumlText Label
highlight default link plantumlClass Type
highlight default link plantumlClassPublic Structure
highlight default link plantumlClassPrivate Macro
highlight default link plantumlClassProtected Statement
highlight default link plantumlClassPackPrivate Function
highlight default link plantumlClassSeparator Comment
highlight default link plantumlSequenceDivider Comment
highlight default link plantumlSequenceSpace Comment
highlight default link plantumlTag Identifier
highlight default link plantumlSequenceDelay Identifier
highlight default link plantumlSpecialString Special
highlight default link plantumlString String
highlight default link plantumlComment Comment
highlight default link plantumlMultilineComment Comment
highlight default link plantumlColonLine Comment
highlight default link plantumlActivityThing Type
highlight default link plantumlActivitySynch Type
highlight default link plantumlActivityLabel String
highlight default link plantumlSkinparamKeyword Identifier
highlight default link plantumlNoteMultiLine String
highlight default link plantumlUsecaseActor String
highlight default link plantumlStereotype Type
highlight default link plantumlBuiltinFunction Function
highlight default link plantumlGanttTask Type

let &cpoptions=s:cpo_orig
unlet s:cpo_orig
