<div id="body">
<form name="listeEleves" id="listeEleves" action="index.php" method="POST" style="padding:0; margin:0">

<input type="hidden" name="educ" value="{$identite.acronyme}">
<input type="hidden" name="date" value="{$date}">
<input type="hidden" name="action" value="">
<input type="hidden" name="mode" value="enregistrer">
<input type="hidden" name="coursGrp" value="{$coursGrp}">
<input type="hidden" name="selectProf" value="{$selectProf}">
<input type="hidden" name="freeDate" value="{$freeDate}">
<input type="hidden" name="freePeriode" value="{$freePeriode}">
<input type="hidden" name="periode" value="{$periode}">
	
<h2>{$listeProfs.$selectProf.prenom} {$listeProfs.$selectProf.nom|truncate:20} | {$listeCoursGrp.$coursGrp.libelle} -> [{$coursGrp}]</h2>
<strong>{$jourSemaine|ucwords} {$date}</strong>
<strong style="float:right">
	[<span class="size150">{$nbEleves}</span> élèves ]
	[Période de cours: <span class="size150">{$periode}</span> ]
	[Absent(s): <span id="nb" class="size150"></span> ]
<input type="submit" name="submit" value="Enregistrer" id="submit"></strong>

<table class="tableauAdmin tableauPresences">
	<tr colspan="6">
		{foreach from=range(0,1) item=col}
		<th width="70">Classe</th>
		<th width="260">Nom Prénom</th>
		<th width="170">Absent</th>
		{/foreach}
	</tr>
	{foreach from=$nbLignes item=noLigne}
	<tr>
		{foreach from=$listeDouble.$noLigne key=matricule item=dataEleve}
			<th>{$dataEleve.classe|default:'&nbsp;'}</th>
			<td class="tooltip col0
			{if isset($listeAbsences) && in_array($periode, $listeAbsences.$matricule)} abs{else}
			{if isset($listeAbsences.$matricule)} abs0{/if}
			{/if}">
				<span class="tip"><img src="../photos/{$dataEleve.photo}.jpg" alt="{$matricule}" width="100px" style="display:none"></span>
				{$dataEleve.nom|default:'&nbsp;'} {$dataEleve.prenom|default:'&nbsp;'} <input type="text" value="rem_{$matricule}" style="display:none"></td>
			<td class="col1
				{if isset($listeAbsences) && in_array($periode, $listeAbsences.$matricule)} abs{else}
				{if isset($listeAbsences.$matricule)} abs0{/if}
				{/if}">
				{if isset($matricule)}
					{foreach from=$lesPeriodes item=noPeriode}
						{if $noPeriode == $periode}
						<input type="checkbox" value="{$matricule}" name="abs_{$matricule}"{if isset($listeAbsences.$matricule) && in_array($noPeriode, $listeAbsences.$matricule)} checked="checked"{/if}>
						{else}
							{if isset($listeAbsences.$matricule) && in_array($noPeriode,$listeAbsences.$matricule)}
							<span class="periode absent">{$noPeriode}</span>
							{else}
								<span class="periode present">{$noPeriode}</span>
							{/if}
						{/if}
					{/foreach}
					{else}&nbsp;
				{/if}
			{* si la deuxième colonne est plus courte d'une unité, on allonge pour compléter la "table" *}
			{if $listeDouble.$noLigne|count == 1}
				<th><td>&nbsp;</td><td>&nbsp;</td></th>	
			{/if}
			</td>
		{/foreach}
	</tr> 
	{/foreach}
</table>


</form>
</div>

<script type="text/javascript">
{literal}
	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	
	$(document).ready(function(){
		
		var nombre = $("#listeEleves").find("input:checked").length;
		$("#nb").text(nombre);
		
		$(".tip img").each(function(el){
			$(this).show();
			})
		
		function modification () {
			if (!(modifie)) {
				modifie = true;
				$("#save").html("<img src='../images/disk.png' alt='S'>");
				window.onbeforeunload = function(){
					var confirmation = confirm(confirmationBeforeUnload);
					$("#wait").hide();
					return confirmation;
					};
				}
		}
		
		// click sur la case à cocher ne provoque aucun effet supplémentaire; tout est traité dans le col1.click
		$(".col1 input[type='checkbox']").click(function(event){
			$(this).parent().trigger("click");

			})
		
		$(".col1").click(function(event){
			modification();
			var checked = $(this).find("input").attr("checked");
			$(this).find("input").attr("checked", !(checked));
			if (checked) {
				$(this).removeClass("abs");
				$(this).prev().removeClass("abs")
				}
				else {
					$(this).addClass("abs");
					$(this).prev("td").addClass("abs");
					}
			})
			
		$("#listeEleves").click(function(){
			var nombre = $(this).find("input:checked").length;
			$("#nb").text(nombre)
			})
	
		$('td').hover(function() {
				$(this).closest('tr').addClass('eleveActif');
				}, function() {
				$(this).closest('tr').removeClass('eleveActif');
				}
			);
		
		$("#listeEleves").submit(function(){
			window.onbeforeunload = function(){};
			})

	})
{/literal}
</script>