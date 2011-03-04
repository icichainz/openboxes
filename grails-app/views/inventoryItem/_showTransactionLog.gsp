<div>							
	<fieldset >
		<legend><span class="fade">Transaction Log</span></legend>
		
		
		<script>
			jQuery(document).ready(function() {
				jQuery(".toggleDetails").click(function(event) {
					//event.preventDefault();
				});
				/*
				jQuery(".toggleDetails").mouseover(function(event) {
					console.log(this.id);
					jQuery("#transactionEntries" + this.id).toggle('slow');								
				});
				jQuery(".toggleDetails").mouseout(function(event) {
					console.log(this.id);
					jQuery("#transactionEntries" + this.id).toggle('slow');								
				});
				*/

				jQuery(".toggleDetails").hoverIntent({
					over: function(event) {
						jQuery("#transactionEntries" + this.id).slideDown('fast');													
					},
					timeout: 500,
					out: function(event) {
						jQuery("#transactionEntries" + this.id).slideUp('fast');								
					}
				});	

				// Define dialog
				jQuery("#transaction-details").dialog({ title: "Transaction Details", 
					modal: true, autoOpen: false, width: 800, height: 400, position: 'middle' });    //end dialog									    

				// Click event -> open dialog
				jQuery('.show-details').click(
			        function(event) {
				        //$("#example").load("", [], function() { 
				        //    jQuery("#example").dialog("open");
				        //});
				        //return false
						var link = $(this);
						var dialog = jQuery('#transaction-details').load(link.attr('href')).dialog("open");										        
				        event.preventDefault();
			        }
			    );											
			});	


			
		</script>
		
		
		<div>
			<g:form method="GET" action="showStockCard">
				<g:hiddenField name="product.id" value="${commandInstance?.productInstance?.id }"/>
				
				<div class="dialog" style="padding: 10px;">
					
					<!--  Filter -->
					<div style="padding: 10px; text-align: center;">
						<g:jqueryDatePicker 
							id="startDate" 
							name="startDate" 
							value="${commandInstance?.startDate }" 
							format="MM/dd/yyyy"
							showTrigger="false" />
						to
						<g:jqueryDatePicker 
							id="endDate" 
							name="endDate" 
							value="${commandInstance?.endDate }" 
							format="MM/dd/yyyy"
							showTrigger="false" />
					</div>
					<div style="padding: 10px; text-align: center;">
						<g:select name="transactionType.id" 
							from="${org.pih.warehouse.inventory.TransactionType.list()}" 
							optionKey="id" optionValue="name" value="${commandInstance?.transactionType?.id }" 
							noSelection="['0': '-- All types --']" /> 
					
						<button  class="" name="filter">
							<img src="${createLinkTo(dir: 'images/icons/silk', file: 'zoom.png' )}" style="vertical-align:middle"/>
							&nbsp;Filter
						</button>
					</div>
				</div>
				
		
				<div class="list">
					<table >
						<thead>
							<tr class="even prop">
								<th>
									${message(code: 'transaction.transactionType.label', default: 'Details')}
								</th>													
								<th>
									${message(code: 'transaction.transactionType.label', default: 'Type')}
								</th>
								<th>
									${message(code: 'transaction.transactionDate.label', default: 'Date')}
								</th>
								<th style="text-align: center">
									${message(code: 'transaction.quantityChange.label', default: 'Qty In/Out')}
								</th>
							</tr>

						</thead>
						<!--  Transaction Log -->
						<tbody>			
							<g:if test="${!commandInstance?.transactionLogMap }">
								<tr>
									<td colspan="4">												
										No transaction entries
									</td>
								</tr>
							</g:if>
							<g:else>
								<g:set var="totalQuantityChange" value="${0 }"/>							
								<g:each var="transaction" in="${commandInstance?.transactionLogMap?.keySet().sort {it.transactionDate}.reverse() }" status="status">
									<tr class="transaction ${(status%2==0)?'odd':'even' } prop">
										<td>	
											<a id="show-details-${transaction?.id }" class="show-details" href="${createLink(controller: 'inventory', action:'showTransactionDialog', id: transaction.id, params: ['product.id', 'test'])}">
												<button>
													<img src="${resource(dir: 'images/icons/silk', file: 'zoom.png')}"/> Show Details
												</button>
											</a>
											
											
											
											<!--  Transaction Details -->
											<span id="transactionEntries${transaction?.id}" style="text-align: left; padding: 10px; margin: 10px; display: none; position:absolute; padding: 10px; background-color: white; border: 1px dashed black">
												<label>Entries for Transaction #${transaction.id }</label>
												<table width="100%">
													<tr> 
														<th>Description</th>
														<th>Serial/Lot Number</th>
														<th style="text-align: center;">Qty Change</th>
													</tr>
													<g:each var="transactionEntry" in="${commandInstance?.transactionLogMap?.get(transaction) }" status="status2">
														<tr class="${(status2%2==0)?'odd':'even' }">
															<td>
																${transactionEntry?.inventoryItem?.product?.name }
																<g:if test="${transactionEntry?.inventoryItem?.description }">
																	&rsaquo;
																</g:if>
																${transactionEntry?.inventoryItem?.description }
															</td>
															<td>
																${transactionEntry?.lotNumber }
															</td>
															<td style="text-align: center;">
																<g:if test="${transactionEntry.quantity<0}">
																	<g:set var="styleClass" value="color: red;"/>																	
																</g:if>
																<span style="${styleClass}">${transactionEntry.quantity }</span> 
																
															</td>
														</tr>
													</g:each>
													<tfoot>
														<tr style="border-top: 1px solid lightgrey;">
															<th colspan="2">
															</th>
															<th style="text-align: center;">

																<g:set var="quantityChange" value="${transaction?.transactionEntries.findAll{it.product == commandInstance?.productInstance}.quantity?.sum() }"/>
																<g:set var="totalQuantityChange" value="${totalQuantityChange + quantityChange}"/>
																																<g:set var="styleClass" value="color:black;"/>														
																<g:if test="${quantityChange<0}">
																	<g:set var="styleClass" value="color: red;"/>																	
																</g:if>
																<span style="${styleClass}">${quantityChange }</span> 
															</th>
														</tr>
													</tfoot>
												</table>
											</span>						
											
																				
										</td>
										<td>
											${transaction?.transactionType?.name }&nbsp;
										
										</td>
										<td>
											<span class="fade">
												<g:formatDate
													date="${transaction?.transactionDate}" format="MMM dd" />																
											</span>
										</td>
										<td style="text-align: center">
											
											<g:set var="styleClass" value="color:black;"/>														
											<g:if test="${quantityChange<0}">
												<g:set var="styleClass" value="color: red;"/>																	
											</g:if>
											<span style="${styleClass}">${quantityChange }</span> 
										</td>
									</tr>
								</g:each>
								<%-- 
								<!-- Commented out because it's a little confusing --> 
								<tr class="prop" style="height: 3em;">
									<td colspan="3" style="text-align: right; font-size: 1.5em; vertical-align: middle;">
										Recent changes
									</td>
									<td style="text-align: center; font-size: 1.5em; vertical-align: middle">
										<g:if test="${totalQuantityChange>0}">${totalQuantityChange}</g:if>
										<g:else><span style="color: red;">${totalQuantityChange}</span></g:else>	
									</td>
								</tr>
								--%>															
							</g:else>
						</tbody>
					</table>
				</div>
			</g:form>
		</div>
		
		
	</fieldset>
</div>
