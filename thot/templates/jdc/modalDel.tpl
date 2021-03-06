<div id="modalDel" class="modal fade" aria-hidden"=true">

    <div class="modal-dialog">

        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" data-target="#modalDel">&times;</button>
                <h4 class="modal-title">Confirmation</h4>
            </div>

            <div class="modal-body">
                <p>Voulez-vous supprimer cette mention au journal de classe?</p>
                <h4>{$travail.categorie}</h4>
                {if $travail.type == 'cours'}
                    <p><strong>{if ($travail.nomCours != '')}{$travail.nomCours}: {/if}{$travail.libelle} {$travail.nbheures}h</strong> [{$travail.destinataire}]</p>
                    {else}
                    <p>Classe: {$travail.destinataire}</p>
                {/if}

                <p>Professeur <strong>{$travail.nom}</strong></p>
                <p><strong>{$travail.title}</strong></p>
                <div>{$travail.enonce}</div>
            </div>

            <div class="modal-footer">
                <form action="index.php" method="POST" name="delete" id="delete" role="form" class="form-vertical">
                    <input type="hidden" name="id" id="id" value="{$travail.id}">
                    <input type="hidden" name="viewState" value="{$viewState}">
                    <input type="hidden" name="startDate" value="{$startDate}">
                    <input type="hidden" name="destinataire" value="{$destinataire}">
                    <input type="hidden" name="type" value="{$type}">
                    <input type="hidden" name="action" value="jdc">
                    <input type="hidden" name="mode" value="delete">
                <button type="submit" class="btn btn-danger"><i class="fa fa-eraser fa-lg"></i> Supprimer</button>
                </form>
            </div>  <!-- modal-footer -->

        </div>  <!-- modal-content -->

    </div>  <!-- modal-dialog -->

</div>  <!-- modalDel -->
