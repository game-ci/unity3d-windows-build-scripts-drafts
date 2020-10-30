const core = require('@actions/core');
const github = require('@actions/github');
const os = require('os');
const child_process = require('child_process');
const process = require('process');
const substitute = require('shellsubstitute');

// If this script becomes a problem, use @actions/exec
// to execute the Unity process
// (see https://github.com/actions/toolkit/tree/master/packages/exec)

try {
    const batchmode = core.getInput('batchmode');
    const buildTarget = core.getInput('buildTarget');
    const disableAssemblyUpdater = core.getInput('disable-assembly-updater');
    const executeMethod = core.getInput('executeMethod');
    const forgetProjectPath = core.getInput('forgetProjectPath');
    const logFile = core.getInput('logFile');
    const nographics = core.getInput('nographics');
    const output = core.getInput('output');
    const profileName = core.getInput('profileName');
    const projectPath = core.getInput('projectPath');
    const quit = core.getInput('quit');
    const runTests = core.getInput('runTests');
    const silentCrashes = core.getInput('silent-crashes');
    const stackTraceLogType = core.getInput('stackTraceLogType');
    const testPlatform = core.getInput('testPlatform');
    const testResults = core.getInput('testResults');
    const unityVersion = core.getInput('unity-version');
    const args = [];

    args.push('-projectPath', substitute(projectPath, process.env));
    if (buildTarget) {
        args.push('-buildTarget', buildTarget);
    }
    if (quit) {
        args.push('-quit');
    }
    if (runTests) {
        args.push('-runTests');
    }
    if (testPlatform) {
        args.push('-testPlatform', testPlatform);
    }
    if (testResults) {
        args.push('-testResults', testResults);
    }
    if (stackTraceLogType) {
        args.push('-stackTraceLogType', stackTraceLogType);
    }
    if (batchmode) {
        args.push('-batchmode');
    }
    if (nographics) {
        args.push('-nographics');
    }
    if (silentCrashes) {
        args.push('-silent-crashes');
    }
    if (disableAssemblyUpdater) {
        args.push('-disable-assembly-updater');
    }
    if (forgetProjectPath) {
        args.push('-forgetProjectPath');
    }
    if (logFile) {
        args.push('-logFile', substitute(logFile, process.env));
    }
    if (executeMethod) {
        args.push('-executeMethod', executeMethod);
    }
    if (profileName) {
        args.push('-profileName', profileName);
    }

    if (output) {
        args.push('-output', substitute(output, process.env));
    }

    let unityPath = "";
    const platform = os.platform();
    switch (platform) {
        case 'win32':
            unityPath = `C:/Program Files/Unity/Hub/Editor/${unityVersion}/Editor/Unity.exe`;
            break;
        case 'darwin':
            unityPath = `/Applications/${unityVersion}/Unity.app/Contents/MacOS/Unity`;
            break;
        case 'linux':
            unityPath = `${os.homedir()}/Unity/Hub/Editor/${unityVersion}/Editor/Unity`;
            break;
        default:
            throw new Error(`${platform} platform not supported, please use win32, darwin, or linux.`);
    }

    core.debug(unityPath);
    core.debug(args);
    const unity = child_process.spawn(
        substitute(unityPath, process.env),
        args,
        {
            windowsHide: true,
            stdio: ['ignore', 'inherit', 'inherit']
        });

    unity.on('disconnect', () => {
        core.info("Action disconnected from child process")
    });

    unity.on('error', (error) => {
        core.setFailed(error.message);
    });

    unity.on('exit', (code, signal) => {
        // We will get either a return code or a signal
        if (code != null) {
            // If the program exited...
            const message = `Unity exited with code ${code}`;

            if (code === 0) {
                // If Unity exited successfully...
                core.info(message);
            } else {
                core.setFailed(message);
            }
        } else if (signal != null) {
            core.info(`Unity exited with signal ${signal}`);
        }
    });

} catch (error) {
    core.setFailed(error.message);
}
