# resource "aws_api_gateway_rest_api" "api" {
#   name        = "example-api"
#   description = "API with mocked endpoint"
# }
# resource "aws_api_gateway_resource" "resource" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
#   path_part   = "mock"
# }
# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_resource.resource.id
#   http_method   = "GET"
#   authorization = "NONE"
# }
# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   resource_id = aws_api_gateway_resource.resource.id
#   http_method = aws_api_gateway_method.method.http_method
#   type        = "MOCK"
#   request_templates = {
#     "application/json" = "{\"statusCode\": 200}"
#   }
# }
# resource "aws_api_gateway_deployment" "deployment" {
#   depends_on  = [aws_api_gateway_integration.integration]
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   stage_name  = "dev"
# }
# output "api_url" {
#   value = "${aws_api_gateway_deployment.deployment.invoke_url}/mock"
# }