exports.handler = async (event) => {
    const AWS = require('aws-sdk');
    const ec2 = new AWS.EC2();
    
    try {
        const instances = await ec2.describeInstances({
            Filters: [{
                Name: 'tag:AutoDestroy',
                Values: ['true']
            }]
        }).promise();
        
        const instanceIds = instances.Reservations
            .map(r => r.Instances)
            .flat()
            .map(i => i.InstanceId);
            
        if (instanceIds.length > 0) {
            console.log(`Terminating instances: ${instanceIds.join(', ')}`);
            await ec2.terminateInstances({
                InstanceIds: instanceIds
            }).promise();
        }
        
        return {
            statusCode: 200,
            body: 'Resources marked for destruction'
        };
    } catch (error) {
        console.error('Error:', error);
        throw error;
    }
};