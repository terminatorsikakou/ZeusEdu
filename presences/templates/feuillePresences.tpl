
<strong>{$jourSemaine|ucwords} {$date}</strong>
<strong style="float:right">
	[<span class="size150">{$nbEleves}</span> élèves ]
	[Période de cours: <span class="size150">{$periode}</span> ]
	[Absents: <span id="nb" class="size150"></span> ]
<span id="save"></span>
<input type="submit" name="submit" value="Enregistrer" id="submit"></strong>

<table class="tableauAdmin tableauPresences">
	<tr>
		{foreach from=range(0,1) item=col}
			<th style="width:60px">Classe</th>
			<th style="width:230px">Nom Prénom</th>
			<th style="width:210px" colspan="{$listePeriodes|@count}">Absent</th>
		{/foreach}
	</tr>
	{assign var=noCol value=0}
	{foreach from=$listeEleves key=matricule item=unEleve}
	
		{assign var=listePr value=$listePresences.$matricule}
		{if ($noCol mod 2) == 0}<tr>{/if}
		<th>{$unEleve.classe|default:'&nbsp;'}</th>

		<td>{$unEleve.nom|default:'&nbsp;'} {$unEleve.prenom|default:'&nbsp;'}</td>

		{* on passe les différentes périodes existantes en revue *}
		{foreach from=$lesPeriodes item=noPeriode}
			{assign var=statut value=$listePr.$noPeriode.statut|default:''}
			<td class="{$statut}{if $noPeriode==$periode} now{/if}">
				{* s'il s'agit de la période actuelle, on présente la case à cocher (éventuellement cochée) *}
				{if ($noPeriode == $periode)}
					{if (in_array($statut, array('sortie','signale','justifie')))}
						<span class="lock" id="lock-{$matricule}_periode-{$noPeriode}"><img src="images/lock.png" alt="X"></span>
						<input type="checkbox" value="{$statut}" name="matr-{$matricule}_periode-{$noPeriode}" class="cb"
							   checked="checked" id="matr-{$matricule}_periode-{$noPeriode}" style="display:none">
					{else}
						<input type="checkbox" value="absent" name="matr-{$matricule}_periode-{$noPeriode}" class="cb" 
							{if $statut=='absent'} checked="checked"{/if}>
					{/if}
				{else}
					<strong>{$noPeriode}</strong>
				{/if}
			</td>
		{/foreach}
				
		{* si c'est la deuxième colonne, on clôture la ligne *}
		{if $noCol mod 2 == 1}</tr>{/if}
		{assign var=noCol value=$noCol+1}
	{/foreach}

	{* s'il reste une colonne non définie, on ajoute les cellules vides correspondantes *}
	{if ($noCol mod 2) == 1}
		<th>&nbsp;</th><td>&nbsp;</td><td>&nbsp;</td></tr>
	{/if}

</table>

</form>

<table class="tableauPresences" style="padding-top:2em">
	<tr>
	<th>Période</th>
	{foreach from=$listePeriodes key=noPeriode item=periode}
		<th>{$noPeriode}</th>
	{/foreach}
	</tr>
	<tr>
	<th>Heures</th>
	{foreach from=$listePeriodes key=noPeriode item=periode}
		<td style="text-align:center">{$periode.debut} à {$periode.fin}</td>
	{/foreach}
	</tr>
</table>

<script type="text/javascript">

	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	var confirmationVerrou = "Souhaitez-vous vraiment déverrouiller cette période?\nÀ n'utiliser que pour noter une présence inattendue."

	$(document).ready(function(){

		var nombre = $(".now.absent").length+$(".now.signale").length+$(".now.sortie").length+$(".now.justifie").length;
		var modifie = false;
		
		$("#nb").text(nombre);

		$(".tip img").each(function(el){
			$(this).show();
			})

		function modification () {
			$("#save").html("<img src='../images/disk.png' alt='S'>");
			if (!(modifie)) {
				modifie = true;
				window.onbeforeunload = function(){
					var confirmation = confirm(confirmationBeforeUnload);
					$("#wait").hide();
					return confirmation;
					};
				}
			}
			
		$("#listeEleves").click(function(){
			var nombre = $("input.cb:checked").length;
			$("#nb").text(nombre);
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

		$("td").has("input:checkbox").click(function(){
			$(this).find('input').trigger('click');
			})

		$(".cb").click(function(event){
			$("#listeEleves").trigger('click');
			if ($(this).parent().hasClass('present')) 
				$(this).parent().removeClass('present').addClass('absent');
				else if ($(this).parent().hasClass('absent') || ($(this).hasClass('signale')))
					$(this).parent().removeClass('absent').addClass('present');
					else if ($(this).parent().hasClass('indetermine'))
						$(this).parent().removeClass('indetermine').addClass('absent');
			modification();

			// le click est géré au niveau du <td>
			event.stopPropagation();
			})

		// il suffit de cliquer sur le <td> contenant les cases à cocher
		$(".tableauPresences td").click(function(e){
			var cb = $(this).nextUntil('th').find('input:checkbox');
			var statut = cb.val();
			cb.trigger('click');
			})
		
		$(".lock").click(function(){
			if (confirm(confirmationVerrou)) {
				$(this).next('input').val('absent');
				var id = $(this).attr("id");
				var part1 = id.substr(0,id.indexOf('_'));
				var matricule = part1.substr(part1.indexOf('-')+1)
				var part2 = id.substr(id.indexOf('_')+1);
				var periode = part2.substr(part2.indexOf('-')+1);
				$(this).hide();
				$("#matr-"+matricule+"_periode-"+periode).show().val("absent").attr("checked",false);
			}
		})

	})

</script>
